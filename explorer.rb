class Explorer
  attr_accessor :excitement, :chaos, :tick
  attr_accessor :x, :y

  def self.add(explorer)
    @explorers ||= []

    @explorers << explorer
  end

  def self.explorers
    @explorers
  end

  def initialize(options)
    @x = (options[:width] / 2.0).round
    @y = (options[:height] / 2.0).round

    @dir = 0
    @tick = 0
    @visited = Set.new
    @scale = options[:scale]

    @start_color = options[:start_color]
    @background_color = options[:background_color]

    @lifetime = 1000
    @max_height = options[:height]
    @max_width = options[:width]

    #@dc = options[:drawing_context]
    @dc = options[:sketch]

    @excitement = 0
    @chaos = 0

    init_sequence

    @visited << [@x, @y]
  end

  def dir_to_v(i)
    [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]][i]
  end

  def init_sequence
    #@next_dir_change  = [1, 1, 5, 4, 1, 2, 5, 5].shuffle.cycle
    #@next_distance = [2, 2, 1, 3, 1, 3, 2, 1, 5, 5, 10, 10, 20].shuffle.cycle

    @next_dir_change  = [1, 1, 5, 4, 1, 2].shuffle.cycle
    @next_distance = [2, 2, 1, 3, 1, 3, 2, 1, 10, 10, 20].shuffle.cycle
  end

  def next_distance
    d = @next_distance.next
  end

  def next_dir
    d = @next_dir_change.next

    return d if !d.is_a?(Fixnum)
    @dir = (@dir + d) % 8
  end

  def start
  end

  def draw_current
    stroke(0xaa, 0x00, 0x00)
    fill(0xaa, 0xaa, 0xaa)
    @dc.ellipse(scale(@x), scale(@y), 10, 10)
  end

  def nudge
    @nudge = true
    @tick -= 200
  end

  def next_step
    return if @tick >= @lifetime
    m = next_distance
    dir = dir_to_v(next_dir)

    if @nudge
      m = 60
      @nudge = false
      dir = dir_to_v(next_dir)
    end

    if m == :bloom
      draw_bloom
      return
    end

    orig_x = @x
    orig_y = @y

    incr_pos(dir[0] * m, dir[1] * m)

    #peek ahead
    if @visited.member?([@x, @y])
      puts 'been here!'
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

  def sign(x)
    if x > 0
      1
    elsif x < 0
      -1
    else
      0
    end
  end

  def incr_pos(dx, dy)
    dx += dx * (100 + @excitement) / 100.0
    dy += dy * (100 + @excitement) / 100.0

    if @chaos.abs > rand(1000)
      next_distance
      @tick -= 500
    end



    @x = ((@x + dx + @max_width) % @max_width).round
    @y = ((@y + dy + @max_height) % @max_height).round
  end

  def draw_skip(x1, y1, x2, y2)
    draw_line(x1, y1, x2, y2)
  end

  def draw_bloom
    @dc.ellipse(scale(@x), scale(@y), 10, 10)
  end

  def draw_line(x1, y1, x2, y2)
    if (x2-x1).abs > 0.70 * @max_width || (y2-y1).abs > 0.70 * @max_height
      return
    end

    x1 = scale(x1)
    y1 = scale(y1)
    x2 = scale(x2)
    y2 = scale(y2)

    c = @start_color

    @dc.strokeWeight(30)
    sc = shadow_color
    @dc.stroke(sc.red, sc.green, sc.blue, current_alpha)
    @dc.line(x1, y1, x2, y2)

    @dc.strokeWeight(3)
    @dc.stroke(c.red, c.green, c.blue, current_alpha * 9.0 / 10.0)
    @dc.line(x1, y1, x2, y2)
  end

  def shadow_color
    c = @start_color
    #@background_color
    Color::RGB.new(0,0,0)
    #Color::RGB.new((c.red + 255.0) / 2.0, (c.green + 255.0) / 2.0, (c.blue + 255.0) / 2.0)
  end

  def current_alpha
    tick = [@tick, 1].max
    life_pct = 1 - tick.to_f / @lifetime.to_f
    chaos_pct = [((100 - @chaos) / 100.0), 1].min
    255 * life_pct * chaos_pct
  end

  def scale(i)
    i * @scale
  end
end
