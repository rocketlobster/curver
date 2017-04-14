require './lib/curver'

RSpec.describe Curver do

  it 'exports ACV file to polynoms' do
    polynoms = {
      rgb: [0.001, 1.671, 0.67, -4.047, 3.805, -1.323, 0.093],
      r:   [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      g:   [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      b:   [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    }
    expect(Curver.new('./specs/support/example.acv').polynoms).to eq(polynoms)
  end

  it 'supports change of max value' do
    Curver.max_value = 1
    polynoms = {
      rgb:  [0.288, 1.671, 0.002, 0.0, 0.0, 0.0, 0.0], 
      r:    [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
      g:    [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0], 
      b:    [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    }
    expect(Curver.new('./specs/support/example.acv').polynoms).to eq(polynoms)
  end

end