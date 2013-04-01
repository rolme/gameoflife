require "./cell.rb"
require "./table.rb"

describe Table do

  describe '#new' do
    it "defaults to nil for a given cell" do
      table = Table.new
      expect(table.square[2][3]).to be_nil
    end
  end

  describe '#deminsions' do
    it "returns [rows, cols]" do
      table = Table.new(rows: 5, cols: 2)
      expect(table.demensions).to eql [5,2]
    end
  end

  describe '#square' do
    it "sets a cell to a given object" do
      table = Table.new
      table.square[2][3] = Cell.new
      expect(table.square[2][3]).to be_a Cell
    end

    it "sets a cell to a Cell object that is alive" do
      table = Table.new
      table.square[2][3] = Cell.new(alive: true)
      expect(table.square[2][3].alive).to be_true
    end
  end

  describe "#neighbors" do
    it "returns a list of 8 neighbor objects for a given coordinate" do
      table = Table.new
      expect(table.neighbors(row: 4, col: 5).length).to be 8
    end

    it "returns a list of 3 neighbor objects for a coordinate [0,0]" do
      table = Table.new
      expect(table.neighbors(row: 0, col: 0).length).to be 3
    end

    it "returns a list of 3 neighbor objects for a coordinate [9,9]" do
      table = Table.new
      expect(table.neighbors(row: 9, col: 9).length).to be 3
    end
  end

end