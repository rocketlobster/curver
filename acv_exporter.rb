################################################################
# USAGE : acv = ACVExporter.new('youracvpath.acv')
#         acv.export_image('image.jpg', 'export_image')
#         acv.export_csv('output.csv')

################################################################

require 'spliner'
require 'matrix'
require 'fileutils'

class ACVExporter

  attr_reader :acv_file_path

  CHANNELS = [:rgb, :r, :g, :b]

  IndexReader       = Struct.new(:position)
  MultiChannelCurve = Struct.new(*CHANNELS)

  ChannelCurve      = Struct.new(:points) do 
    
    def range
      @range ||= ACVExporter.range(self.points)
    end

    def polynom
      @polynom ||= ACVExporter.compute_polynom(points, range)
    end

  end

  def initialize(acv_file_path)
    raise "No file at this path" unless File.exist?(acv_file_path)
    self.class.set_default_values
    @acv_file_path = acv_file_path
  end

  def curves
    @curves ||= self.class.read_curves(acv_file_path)
  end

  def export_image(original_path, export_base_name)
    self.class.export_image(curves, original_path, export_base_name)
  end

  def compute_polynoms
    CHANNELS.each do |channel|
      puts "#{ channel }: #{ curves[channel].polynom }  -- (x^0 -> x^n)"
    end
  end

  class << self 

    attr_accessor :polynom_degree, :max_value, :range_size, :polynom_precision

    def set_default_values
      self.polynom_degree    ||= 6
      self.max_value         ||= 255
      self.range_size        ||= 255  
      self.polynom_precision ||= 3    
    end

    def read_curves file_path
      ary = File.read(file_path, encode: 'binary').unpack('S>*')
      multi_channel_curve(ary)
    end

    def multi_channel_curve ary
      ir = IndexReader.new(2)
      channels_points = CHANNELS.map { |k| sanitize_points read_array!(ary, ir) }
      channels_curves = channels_points.map{ |points| ChannelCurve.new(points) }
      MultiChannelCurve.new(*channels_curves)
    end

    def compute_polynom points, range
      values = spline_values(points, range)
      polynom(range, values)
    end

    def sanitize_points array
      ary = (array.length / 2).times.map{|i| [array[2*i+1], array[2*i]]}
      ary.map{ |dot| dot.map{ |v| v / max_value.to_f } }
    end

    def read_array! array, index_reader
      ary = array.drop(index_reader.position)
      raise 'Wrong index reader position' if ary.empty?
      points_count = (ary.first * 2)
      index_reader.position += points_count + 1
      ary[1..points_count]
    end

    def polynom x, y
      x_data = x.map { |xi| (0..polynom_degree).map { |pow| (xi**pow).to_f } }
      mx = Matrix[*x_data]
      my = Matrix.column_vector(y)
      ((mx.t * mx).inv * mx.t * my).transpose.to_a[0].map{|e| truncate(e, polynom_precision) }
    end
    
    def truncate i, length
      (i * (10 ** length)).to_i.to_f / (10 ** length)
    end

    def spline_values(coords, range)
      spline = Spliner::Spliner.new coords.map(&:first), coords.map(&:last)
      spline[range]
    end
    
    def range coords
      min_value, max_value = coords.first.first, coords.last.first
      (min_value..max_value).step((max_value - min_value)/range_size).to_a
    end

    def export_image(curves, image_path, export_base_name)
      FileUtils.cp image_path, export_base_name
      CHANNELS.each do |channel|
        magick_string = curves[channel].polynom.reverse.join(',')
        puts "#{ channel }: #{ curves[channel].polynom }  -- (x^0 -> x^n)"
        `convert #{ export_base_name } -channel #{ channel.to_s.upcase } -function Polynomial #{ magick_string } #{export_base_name}`
      end
    end
  
  end

end