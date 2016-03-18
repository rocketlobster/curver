# ACV Exporter

Small ruby script to convert Photoshop curve file into polynoms, for further use with image processing library

## Usage
    acv = ACVExporter.new('example.acv')
    acv.export('output.csv')
    acv.export_images('image.jpg', 'export_image_base_name')
