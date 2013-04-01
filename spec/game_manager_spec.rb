require "./game_manager.rb"

describe GameManager do
  let(:gm) { GameManager.new }
  let(:board) { gm.board }

  describe '#new' do
    it "raises an error if seed is larger than board size (size**2)" do
      expect{ GameManager.new(size: 5, seed: 101) }.to raise_error
    end
  end

  describe '#seed_board' do
    it "seeds board with default number of living cells" do
      gm.seed_board
      expect(gm.living).to be 20
    end

    it "seeds board with given number of living cells" do
      gm.seed_board seed: 5
      expect(gm.living).to be 5
    end

    it "raises an error if seed is larger than board size (size**2)" do
      expect{ gm.seed_board(seed:101) }.to raise_error
    end
  end

  describe '#living_neighbors' do
    it "gives a list of living neighbors" do
      board.square[2][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.living_neighbors(row: 2, col:  3).length).to be 3
    end
  end

  describe '#overcrowded?' do
    it "returns false if cell is dead" do
      board.square[2][3] = Cell.new(alive: false)

      board.square[2][2] = Cell.new(alive: true)
      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.overcrowded?(row: 2, col:  3)).to be_false
    end

    it "returns true if it has 4 or more living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[2][2] = Cell.new(alive: true)
      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.overcrowded?(row: 2, col:  3)).to be_true
    end

    it "returns true if it has 3 or less living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.overcrowded?(row: 2, col:  3)).to be_false
    end
  end

  describe '#underpopulated?' do
    it "returns false if cell is dead" do
      board.square[2][3] = Cell.new(alive: false)

      board.square[2][2] = Cell.new(alive: true)
      expect(gm.underpopulated?(row: 2, col:  3)).to be_false
    end

    it "returns true if it has less than 2 living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[2][2] = Cell.new(alive: true)
      expect(gm.underpopulated?(row: 2, col:  3)).to be_true
    end

    it "returns false if it has 2 or more living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[2][2] = Cell.new(alive: true)
      board.square[3][2] = Cell.new(alive: true)
      expect(gm.underpopulated?(row: 2, col:  3)).to be_false
    end
  end

  describe '#revive?' do
    it "returns false if cell is alive" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.revive?(row: 2, col:  3)).to be_false
    end

    it "returns true if it has 3 living nieghbors" do
      board.square[2][3] = Cell.new(alive: false)

      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.revive?(row: 2, col:  3)).to be_true
    end

    it "returns false if does not have 3 living nieghbors" do
      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      expect(gm.revive?(row: 2, col:  3)).to be_false
    end
  end

  describe '#live?' do
    it "returns false if cell is dead" do
      board.square[2][3] = Cell.new(alive: false)

      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.live?(row: 2, col:  3)).to be_false
    end

    it "returns true if it has 2 living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.live?(row: 2, col:  3)).to be_true
    end

    it "returns true if it has 3 living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.live?(row: 2, col:  3)).to be_true
    end

    it "returns false if it has less than 2 living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[3][3] = Cell.new(alive: true)
      expect(gm.live?(row: 2, col:  3)).to be_false
    end

    it "returns false if it has greater than 3 living nieghbors" do
      board.square[2][3] = Cell.new(alive: true)

      board.square[2][2] = Cell.new(alive: true)
      board.square[3][2] = Cell.new(alive: true)
      board.square[3][3] = Cell.new(alive: true)
      board.square[2][4] = Cell.new(alive: true)
      expect(gm.live?(row: 2, col:  3)).to be_false
    end
  end

  describe "#generate_board" do
    it "creates a new board based on existing size" do
      new_board = gm.generate_board
      expect(new_board.demensions).to eql gm.board.demensions
    end
  end

 describe '#tick' do
    it "creates a new board applying all rules" do
      old_board = gm.board.clone
      gm.tick
      expect(gm.board).to_not eql old_board
    end
  end
end
