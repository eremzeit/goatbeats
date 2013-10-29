require 'set'
require './drawing.rb'
require './drawing_context.rb'
require './explorer.rb'

class My_Sketch < Processing::App
  def setup
    @frame = 0
    width = 1200
    height = 700
    scale = 1
    size(width, height)
    background(0x0, 0x0, 0x0)
    frameRate(40)

    @dc = DrawingContext.new(self)

    @excitement = 0
    @chaos = 0

    @explorers = (0...1).map do
      e = Explorer.new(
        :width => width / scale,
        :height => height / scale,
        :scale => scale,
        :start_color => nil,
        :drawing_context => @dc
      )
      e
    end
  end

  def draw
    if !@paused
      @explorers.each do |e|
        e.excitement = @excitement
        e.chaos = @chaos

        (0..20).each do
          e.next_step
        end
      end

      puts "Prims count: #{@dc.prims.length}"

      #translate(width/1000*@frame, height/1000*@frame);
      rotate(PI/1000.0 * @frame);
      background(0,0,0)
      @dc.paint
      @frame += 1
    end

  end

  def keyPressed(event)
    if event.keyChar == 99 # 'c'
      save("captures/line-#{@frame}.png");
    elsif event.keyChar == 106 # 'j'
      @excitement += 1
    elsif event.keyChar == 107 # 'k'
      @excitement -= 1
    elsif event.keyChar == 104 # 'h'
      @chaos += 1
    elsif event.keyChar == 108 # 'l'
      @chaos -= 1
    elsif event.keyChar == 110 # 'n'
      @explorers.each do |e|
        e.nudge
      end
    elsif event.keyChar == 112 # 'p'
      @paused = !@paused
    end
  end

  def mouseClicked
    @explorers.each do |e|
      e.x = mouseX
      e.y = mouseY
    end
  end
end

