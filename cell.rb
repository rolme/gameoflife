class Cell
  attr_accessor :alive

  def initialize (args={})
    @alive = (args[:alive].nil? || args[:alive] == false) ? false : true
  end

  def alive?
    alive
  end
end