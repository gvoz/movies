require_relative '../movies'

describe MovieCollection do
  context '#filter' do
    let!(:movies) { MovieCollection.new('spec/data/movies_filter.txt') }

    it 'name' do
      expect(movies.filter(name: 'Rocky').size).to eq(1)
      expect(movies.filter(name: /The/).size).to eq(4)
    end

    it 'year' do
      expect(movies.filter(year: 1975).size).to eq(2)
      expect(movies.filter(year: 2000..2010).size).to eq(3)
    end

    it 'country' do
      expect(movies.filter(country: 'UK').size).to eq(3)
    end

    it 'genre' do
      expect(movies.filter(genre: 'Action').size).to eq(3)
      expect(movies.filter(genre: ['Action', 'Adventure']).size).to eq(4)
    end

    it 'director' do
      expect(movies.filter(director: 'Stanley Kubrick').size).to eq(1)
      expect(movies.filter(director: /Avildsen/).size).to eq(1)
    end

    it 'actors' do
      expect(movies.filter(actors: /Sylvester Stallone/).size).to eq(1)
    end
  end
end
