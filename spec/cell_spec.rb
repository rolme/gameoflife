require "./cell.rb"

describe Cell do
  describe '#new' do
    it "defaults to not alive" do
      cell = Cell.new
      cell.should_not be_alive
    end

    it "is dead if initialized alive to false" do
      cell = Cell.new(alive: false)
      expect(cell).to_not be_alive
    end

    it "is alive if initialized alive to true" do
      cell = Cell.new(alive: true)
      expect(cell).to be_alive
    end
  end

  describe '#alive' do
    let(:cell) { Cell.new }
    it "is alive if assigned alive to true" do
      cell.alive = true
      expect(cell).to be_alive
    end

    it "is alive if assigned alive to true" do
      cell.alive = false
      expect(cell).to_not be_alive
    end
  end
end
