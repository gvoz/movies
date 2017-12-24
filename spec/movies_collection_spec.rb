require_relative '../app/movies'

describe Movies::MovieCollection do
  describe '#filter' do
    let(:movies) { Movies::MovieCollection.new('spec/data/movies_filter.txt') }

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

    it 'unknown field' do
      expect{movies.filter(budget: 1000)}.to raise_error("В описании фильма нет поля budget")
    end

    it 'block' do
      expect(movies.filter(block: proc { |movie| movie.actors.include?('Clint Eastwood') }).size).to eq(1)
      expect(movies.filter(block: proc { |movie| movie.genre.include?('Action') && movie.year > 2000 }).size).to eq(2)
    end
  end
end
