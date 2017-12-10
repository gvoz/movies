require_relative '../movies'

describe Movie do
  context '#to_s' do
    let!(:movies) { MovieCollection.new('spec/data/movies.txt') }

    it 'ancient'do
      ancient = movies.filter(year: 1900...1945).first
      expect(ancient.to_s).to eq("#{ancient.name} — старый фильм (#{ancient.year} год)")
    end

    it 'classic' do
      classic = movies.filter(year: 1945...1968).first
      expect(classic.to_s).to eq("#{classic.name} — классический фильм, режиссёр #{classic.director} (ещё #{movies.filter(director: classic.director).size} его фильмов в спике)")
    end

    it 'modern' do
      modern = movies.filter(year: 1968...2000).first
      expect(modern.to_s).to eq("#{modern.name} — современное кино: играют #{modern.actors.join(', ')}")
    end

    it 'new' do
      new_film = movies.filter(year: 2000...2017).first
      expect(new_film.to_s).to eq("#{new_film.name} — новинка, вышло #{DateTime.now.year - new_film.year} лет назад!")
    end
  end
end
