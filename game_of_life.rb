require_relative 'game_manager'

class GameOfLife
  attr_reader :size, :seed, :gm

  def initialize(args={})
    @size  = args[:size] || 10
    @seed  = args[:seed] || 25
    @gol   = nil

    @gm = GameManager.new size: @size, seed: @seed
    @gm.seed_board
  end

  def run
    @gol = Thread.new do
      loop do
        gm.display_board
        gm.display_stats
        gm.tick
        sleep 1
      end
    end
    wait_for_input
  end

  def wait_for_input
      STDIN.gets
      stop
  end

  def status
    @gol.status
  end


  def stop
    @gol.kill
  end
end

if $0 == __FILE__
  size = ARGV[0] || 10
  seed = ARGV[1] || 35

  gol = GameOfLife.new size: size.to_i, seed: seed.to_i
  gol.run
end