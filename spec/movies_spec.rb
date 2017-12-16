require_relative '../app/movies'

describe Movies::Movie do
  context '#to_s' do
    let(:movies) { Movies::MovieCollection.new('spec/data/movies.txt') }
    subject { movie.to_s }

    context 'when AncientMovie' do
      let(:movie) { movies.filter(year: 1900...1945).first }
      it { is_expected.to eq("#{movie.name} — старый фильм (#{movie.year} год)") }
    end

    context 'when ClassicMovie' do
      let(:movie) { movies.filter(year: 1945...1968).first }
      it { is_expected.to eq("#{movie.name} — классический фильм, режиссёр #{movie.director} (ещё #{movies.filter(director: movie.director).size} его фильмов в спике)") }
    end

    context 'when ModernMovie' do
      let(:movie) { movies.filter(year: 1968...2000).first }
      it { is_expected.to eq("#{movie.name} — современное кино: играют #{movie.actors.join(', ')}") }
    end

    context 'when NewMovie' do
      let(:movie) { movies.filter(year: 2000...2017).first }
      it { is_expected.to eq("#{movie.name} — новинка, вышло #{DateTime.now.year - movie.year} лет назад!") }
    end
  end
end
