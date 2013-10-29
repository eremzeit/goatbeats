require 'set'

class Explorer

  def self.add(explorer)
    @explorers ||= []

    @explorers << explorer
  end

  def self.explorers
    @explorers
  end

  def initialize(width, height, scale)
    @x = rand(width)
    @y = rand(height)
    @dir = 0
    @tick = 0
    @visited = Set.new
    @scale = scale

    @lifetime = 2
    @max_height = height
    @max_width = width

    init_sequence

    stroke(100)
    color(100)
    ellipse(@x, @y, 3, 3)

    @visited << [@x, @y]
    draw_current
  end

  def dir(i)
    [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]][i]
  end

  def init_sequence
    @next_dir_change  = [1, 1, 1, 1, 1, 1].cycle
    @next_distance = [1, 1, 1, 1, 1, 1].cycle
    #@next_dir_change  = [1, 2, 3, 2, 1, 7, :bloom].cycle
    #@next_distance = [2, 3, 1, 5, 2, 7, :bloom].cycle
  end

  def next_distance
    @next_distance.next
  end

  def next_dir
    d = @next_dir_change.next

    return d if !d.is_a?(Fixnum)
    @dir = (@dir + d) % 8
  end

  def start
    while @tick < @lifetime
      next_step
    end
  end

  def draw_current
    stroke(0xaa, 0x00, 0x00)
    fill(0xaa, 0xaa, 0xaa)
    ellipse(scale(@x), scale(@y), 10, 10)
  end

  def next_step
    puts 'next...'
    m = next_distance
    dir = next_dir

    if m == :bloom
      draw_bloom
      return
    end

    orig_x = @x
    orig_y = @y

    incr_pos(dir[0] * m, dir[1] * m)

    #peek ahead
    if @visited.member?([@x, @y])
      while @visited.member?([@x, @y])
        draw_skip(orig_x, orig_y, @x, @y)
        incr_pos(dir[0] * m, dir[1] * m)
      end

      draw_skip(orig_x, orig_y, @x, @y)
    else
      draw_line(orig_x, orig_y, @x, @y)
    end

    @tick += 1
  end

  def incr_pos(dx, dy)
    @x = ((@x + dx + @max_width) % @max_width).round
    @y = ((@y + dy + @max_height) % @max_height).round
  end

  def draw_skip(x1, y1, x2, y2)
    x1 = scale(x1)
    y1 = scale(y1)
    x2 = scale(x2)
    y2 = scale(y2)

    draw_line(x1, y1, x2, y2)
    stroke(0x00, 0x00, 0x90)
    fill(0x00000000)
    ellipse(scale(@x), scale(@y), 5, 5)
  end

  def draw_bloom
    fill(0x005aff99)
    ellipse(scale(@x), scale(@y), 10, 10)
  end

  #def distance(x1, y1, x2, y2)
  #
  #end

  def draw_line(x1, y1, x2, y2)
    if (x2-x1).abs > 0.95 * @max_width || (y2-y1).abs > 0.95 * @max_height
      return
    end


    x1 = scale(x1)
    y1 = scale(y1)
    x2 = scale(x2)
    y2 = scale(y2)

    strokeWeight(1)

    stroke(255)
    line(x1, y1, x2, y2)
    #stroke(0xff, 0xff, 0xff)
    #ellipse(x2, y2, 2, 2)
  end

  def scale(i)
    i * @scale
  end
end

def setup
  width = 1200
  height = 700
  scale = 7
  size(width, height)
  background(0x20, 0x20, 0x20)
  frameRate(40)
  @e = Explorer.new(width / scale, height / scale, scale)
  @e.start
end

def draw
  @e.next_step
end
