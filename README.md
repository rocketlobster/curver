# ACV Exporter

Small ruby script to convert Photoshop curve file into polynoms, for use with ImageMagick

## Usage
    acv = ACVExporter.new("youracvpath.acv")
    acv.export_images("image.jpg", "export_image")
