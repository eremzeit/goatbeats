class Prim
  attr_accessor :color, :args
end

class Arc < Prim
  def initialize(*args)
    @args = args
  end
end

class Line < Prim
  def initialize(*args)
    @args = args
  end
end

class Ellipse < Prim
  def initialize(*args)
    @args = args
  end
end

class Point < Prim
  def initialize(*args)
    @args = args
  end
end

class Quad < Prim
  def initialize(*args)
    @args = args
  end
end

class Rect < Prim
  def initialize(*args)
    @args = args
  end
end

class Triangle < Prim
  def initialize(*args)
    @args = args
  end
end


