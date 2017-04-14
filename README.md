# Curver (ACV Exporter)

Convert Adobe Photoshop curves files into polynoms, for further use with image processing libraries (ImageMagick, Javascript canvas, etc.)

## Installation

    gem install curver

Or in Gemfile :

    gem 'curver'

### Usage:

    acv = Curver.new('example.acv')
    acv.polynoms

## Settings

  You can specify the polynom_degree, the max_value that you want, or the polynom_precision. 
  By default: 

    Curver.polynom_degree    = 6
    Curver.max_value         = 255
    Curver.polynom_precision = 3   