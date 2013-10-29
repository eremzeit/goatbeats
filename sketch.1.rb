
class Explorer

  def self.add(explorer)
    @explorers ||= []

    @explorers << explorer
  end

  def self.explorers
    @explorers
  end

  def initialize(width, height)
    init_sequence
    @scale = 1
    @x = rand(width)
    @y = rand(height)

    @max_height = height
    @max_width = width

    stroke(100)
    color(100)
    ellipse(@x, @y, 3, 3)
  end

  def init_sequence
    @sequence = (0...50).to_a.shuffle.cycle
  end

  def start
    (0...100).each do
      next_step
    end
  end

  def next_step
    num = @sequence.next
    num *= @scale

    puts "num = #{num}"
    if num.to_i % 2 == 0
      dx = num * 2.0 / 3.0 * rand(3) - 1
      dy = num * 1.0 / 3.0 * rand(3) - 1
    else
      dx = num * 1.0 / 3.0 * rand(3) - 1
      dy = num * 2.0 / 3.0 * rand(3) - 1
    end

    #wall_push
    x_push, y_push = wall_push
    dx += x_push.to_i
    dy += y_push.to_i

    draw_line(@x, @y, @x + dx, @y + dy)

    @x += dx
    @x = [@x, 0].max
    @x = [@x, @max_width].min

    @y += dy
    @y = [@y, 0].max
    @y = [@y, @max_height].min

    @scale -= @scale / 100.0
  end

  def wall_push
    x_push = 0
    y_push = 0
    push_const = @max_height / 30.0
    x_push += (@max_width - @x) / @max_width
    x_push += - @x / @max_width

    y_push += (@max_height - @y) / @max_height
    y_push += - @y / @max_height

    [x_push * push_const, y_push * push_const]
  end

  def draw_line(x1, y1, x2, y2)
    strokeWeight(3.0 * @scale ** 2.0)

    c = (@scale ** 3) * 255
    stroke(c)
    line(x1, y1, x2, y2)
    #stroke(0xff, 0xff, 0xff)
    #ellipse(x2, y2, 2, 2)
  end
end

def setup
  width = 1200
  height = 700
  size(width, height)
  background(0x30, 0x30, 0x40)

  (0...50).each do
    e = Explorer.new(width, height)
    e.start
    Explorer.add(e)
  end
end

def draw
  #Explorers.explorers.each  {|e| e.next_step }
end
