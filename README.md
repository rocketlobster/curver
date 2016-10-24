# ACV Exporter

Small ruby script to convert Photoshop curve file into polynoms, for further use with image processing library

## Usage

### In ruby IRB:

    acv = ACVExporter.new('example.acv')
    acv.compute_polynoms

  If you have ImageMagick, you can export the image: 
    acv.export_image('image.jpg', 'output.jpg')

### In command line:

    ./acv_export_polynoms example.acv 

    ./acv_export_image example.acv image.jpg output_path.jpg

## Settings

  You can specify the polynom_degree, the max_value that you want, or the polynom_precision by setting it as a class variable. 
  By default: 

    ACVExporter.polynom_degree    = 6
    ACVExporter.max_value         = 255
    ACVExporter.polynom_precision = 3   