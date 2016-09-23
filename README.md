# ACV Exporter

Small ruby script to convert Photoshop curve file into polynoms, for further use with image processing library

## Usage
  In ruby irb:

    acv = ACVExporter.new('example.acv')
    acv.export_image('image.jpg', 'output.jpg')

  or in command line:

    acv_export example.acv image.jpg output_path.jpg
