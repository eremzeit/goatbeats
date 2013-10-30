require 'set'
require './drawing.rb'
require './drawing_context.rb'
require './explorer.rb'
require 'color'

class My_Sketch < Processing::App
  def setup
    @frame = 0
    width = 1200
    height = 700
    scale = 1
    size(width, height)
    @bg = Color::RGB.new(0x3a, 0x40, 0x40)
    background(@bg.red, @bg.green, @bg.blue)
    frameRate(40)

    @excitement = 0
    @chaos = 0

    @explorers = (0...1).map do
      e = Explorer.new(
        :width => width / scale,
        :height => height / scale,
        :scale => scale,
        #:start_color => Color::RGB.new(0x6f, 0x91, 0xd1),
        :start_color => Color::RGB.new(0x20, 0xfe, 0xd7),
        :sketch => self
      )
      e
    end
  end

  def draw
    if !@paused
      @explorers.each do |e|
        e.excitement = @excitement
        e.chaos = @chaos

        (0..5).each do
          e.next_step
        end
      end

      @frame += 1
    end

  end

  def keyPressed(event)
    if event.keyChar == 99 # 'c'
      save("captures/line-#{@frame}.png");
    elsif event.keyChar == 106 # 'j'
      @excitement += 2
    elsif event.keyChar == 107 # 'k'
      @excitement -= 2
    elsif event.keyChar == 104 # 'h'
      @chaos -= 5
    elsif event.keyChar == 108 # 'l'
      @chaos += 5
    elsif event.keyChar == 113 # 'q'
      exit
    elsif event.keyChar == 100 # 'd'
      background(@bg.red, @bg.blue, @bg.green)
    elsif event.keyChar == 110 # 'n'
      @explorers.each do |e|
        e.nudge
      end
    elsif event.keyChar == 112 # 'p'
      @paused = !@paused
    end
  end

  def mouseClicked
    puts 'click!'
    puts mouseX
    puts mouseY
    @explorers.each do |e|
      e.tick = 0
      e.x = mouseX
      e.y = mouseY
    end
  end
end

