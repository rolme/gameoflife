require './game_of_life.rb'

describe GameOfLife do
  describe '#new' do
    let(:game) { GameOfLife.new(size: 12, seed: 40) }

    it "initiates the game with a given size" do
      expect(game.gm.size).to be 12
    end

    it "initiates the game with a given seed" do
      expect(game.gm.living).to be 40
    end
  end

  describe '#run' do
    let(:game) { GameOfLife.new }

    it "starts the game" do
      game.gm.stub(:display_board) { }
      game.gm.stub(:display_stats) { }
      game.stub(:wait_for_input) { }

      game.run
      expect(game.status).to eql "run"
      game.stop
    end
  end
end