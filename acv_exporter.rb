################################################################
# USAGE : acv = ACVExporter.new("youracvpath.acv")
#         acv.export_images("image.jpg", "export_image")
################################################################

require 'spliner'
require 'matrix'

class ACVExporter

  attr_reader :acv_file_path

  def initialize(acv_file_path)
    @acv_file_path = acv_file_path
  end

  def polynoms
    rationalized_coords = self.class.acv_coords(acv_file_path)
    total_range         = self.class.range(rationalized_coords, 255)
    values              = self.class.spline_values(rationalized_coords, total_range)
    10.times.map { |degree| self.class.polynom(total_range, values, degree) }
  end

  def export_images(original_path, export_base_name)
    self.class.export_images(polynoms, original_path, export_base_name)
  end

  class << self

    def polynom x, y, degree
      x_data = x.map { |xi| (0..degree).map { |pow| (xi**pow).to_f } }
      mx = Matrix[*x_data]
      my = Matrix.column_vector(y)
      ((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
    end
    
    def excel_formula(polynom)
      ->(x) do
        monoms = p.length.times.map{|i| "(#{ p[i] }*#{ x }^#{ i })".gsub("*#{ x }^0", '') }
        "=#{monoms.join('+')}"
      end
    end
    
    def export_csv_file(range, polynom_ary, export_path)
      formulas = polynom_ary.map{ |p| excel_formula(p) }
      computed = formulas.map do |polynom|
        range.length.times.map{|v| polynom["A#{ v.to_i + 1 }"] }
      end
      ary = range.zip(ys,*computed)
      CSV.open(export_path, 'wb', col_sep: ',') do |csv|
        ary.each do |l|
          csv << l
        end
      end
    end
    
    def export_images(polynom_ary, image_path, export_base_name)
      polynom_ary.each_with_index do |p, i|
        magick_string = p.reverse.join(',')
        `convert #{ image_path } -function Polynomial #{ magick_string } #{export_base_name}_#{i}.jpg`
        puts "Polynom degree #{ p.length - 1 }: #{magick_string}"
      end
    end
    
    def acv_coords(acv_path)
      ary = File.read(acv_path, encode: 'binary').unpack('S>*')
      points_count = ary[2]
      points = ary[3..(3 + points_count * 2 - 1)]
      dary = points_count.times.map{|i| [points[2*i+1], points[2*i]]}
      dary.map{ |dot| dot.map{ |v| v / 255.0 } }
    end
    
    def spline_values(coords, range)
      spline = Spliner::Spliner.new coords.map(&:first), coords.map(&:last)
      spline[range]
    end
    
    def range(coords, points_quantity)
      min_value, max_value = coords.first.first, coords.last.first
      (min_value..max_value).step((max_value - min_value)/points_quantity).to_a
    end

  end

end

