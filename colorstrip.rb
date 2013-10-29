require 'color'

def color_map(i)
  color(i, i, i)
end

def setup
  background(0)
  size(300, 600)

  (0...255) do |i|
    color_map(i)
    line(50, 200 + i, 250, 200 + i)
  end
end

def draw

end
