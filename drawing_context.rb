class DrawingContext
  attr_accessor :prims, :sketch

  def initialize(sketch)
    @sketch = sketch
    @prims = []
  end

  def add(type, *args)
    @prims << constantize(type.to_s).new(*args)
  end

  def constantize(s)
    name = s.capitalize!
    if Object.const_defined?(name)
      Object.const_get(name)
    else
      puts 'Cant find ' + s.to_s
      nil
    end
  end

  def clear
    @prims = []
  end

  def paint
    @prims.each do |prim|
      puts "Calling #{prim.class.to_s.downcase}(#{prim.args.join(', ')})"
      @sketch.send(prim.class.to_s.downcase, *prim.args)
    end
  end

  def method_missing(m, *args, &block)
    if [:line, :ellipse, :point, :quad, :rect, :triangle].include?(m.to_sym)
      add(m, *args)
    elsif [:stroke, :color, 'strokeWeight'.to_sym].include?(m.to_sym)
      @sketch.send(m.to_sym, *args)
    else
      super(m, *args, &block)
    end
  end
end
