class Table
  attr_accessor :rows, :cols, :square

  def initialize(args={})
    @rows = args[:rows] || 10
    @cols = args[:cols] || 10
    @obj = args[:obj] || nil
    @square = []
    (0..@rows-1).each do |i|
      @square << Array.new(@cols-1, nil)
    end

    if !@obj.nil?
      (0..@rows-1).each do |row|
        (0..@cols-1).each do |col|
          @square[row][col] = @obj.new
        end
      end
    end

  end

  def demensions
    [rows, cols]
  end

  def neighbors(args)
    my_row = args[:row]
    my_col = args[:col]

    my_neighbors = []
    (my_row-1..my_row+1).each do |r|
      next if r < 0 || r >= self.rows
      (my_col-1..my_col+1).each do |c|
        next if c < 0 || c >= self.cols
        next if r == my_row && c == my_col
        my_neighbors << square[r][c]
      end
    end
    my_neighbors
  end

 end