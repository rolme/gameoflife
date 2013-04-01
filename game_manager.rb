require_relative "cell"
require_relative "table"

class GameManager
  attr_accessor :board, :size, :seed, :born, :died, :prospered

  # Look to delegate :square to Table

  def initialize(args={})
    @size = args[:size] || 10
    @seed = args[:seed] || 20
    raise ArgumentError, "seed is larger than board size (size**2)" if size**2 < seed
    @born = 0
    @died = 0
    @prospered = 0

    @board = Table.new(rows: size, cols: size, obj: Cell)
    #seed_board
  end

  def seed_board(args={})
    my_seed = args[:seed] || seed
    raise ArgumentError, "seed is larger than board size (size**2)" if size**2 < my_seed
    my_seed.times do
      loop do
        c = rand(size)
        r = rand(size)
        if !board.square[r][c].alive?
          board.square[r][c].alive = true
          break
        end
      end
    end
  end

  def living
    count = 0
    (0..size-1).each do |row|
      (0..size-1).each do |col|
        count += 1 if board.square[row][col].alive?
      end
    end
    count
  end

  def overcrowded?(args)
    row = args[:row]
    col = args[:col]

    return false if !board.square[row][col].alive?
    living_neighbors(row: row, col: col).length > 3
  end

  def underpopulated?(args)
    row = args[:row]
    col = args[:col]

    return false if !board.square[row][col].alive?
    living_neighbors(row: row, col: col).length < 2
  end

  def live?(args)
    row = args[:row]
    col = args[:col]

    return false if !board.square[row][col].alive?
    !overcrowded?(row: row, col: col) && !underpopulated?(row: row, col: col) 
  end

  def revive?(args)
    row = args[:row]
    col = args[:col]

    return false if board.square[row][col].alive?
    living_neighbors(row: row, col: col).length == 3
  end

  def living_neighbors(args)
    row = args[:row]
    col = args[:col]

    n = []
    board.neighbors(row: row, col: col).each do |s|
      next if s.nil?
      n << s if s.alive?
    end
    n
  end

  def generate_board
    Table.new(rows: size, cols: size, obj: Cell)
  end

  def tick
    self.born = 0
    self.died = 0
    self.prospered = 0
    new_board = generate_board
    (0..size-1).each do |row|
      (0..size-1).each do |col|
        if board.square[row][col].alive?
          if !live?(row: row, col: col)
            new_board.square[row][col].alive = false 
            self.died += 1
          end

          if live?(row: row, col: col)
            new_board.square[row][col].alive = true
            self.prospered += 1
          end
        else
          if revive?(row: row, col: col)
            new_board.square[row][col].alive = true
            self.born += 1
          end
        end
      end
    end
    self.board = new_board
  end

  def display_stats
    puts "Living: #{'%02d' % living} | Born: #{'%02d' % born} | Died: #{'%02d' % died} | Prospered: #{'%02d' % prospered}"
  end

  def display_board
    print "|    |"
    (0..size-1).each do |col|
        print " #{'%02d' % col} |" 
    end
    puts
    (size+1).times { print '-----' }
    puts

    (0..size-1).each do |row|
      print "| #{'%02d' % row} |"
      (0..size-1).each do |col|
        if board.square[row][col].alive?
          print "  X |" 
        else
          print "    |"
        end
      end
    puts
    (size+1).times { print '-----' }
    puts
    end
  end

end

if $0 == __FILE__
  gm = GameManager.new
  20.times do
    gm.board.square[rand(gm.size)][rand(gm.size)].alive = true
  end
  gm.display_board
  gm.tick
  puts "tick"
  gm.display_board
end