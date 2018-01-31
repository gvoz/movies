require_relative '../app/movies'

describe Movies::Period do
  let(:movies) { Movies::MovieCollection.new('spec/data/movies.txt') }
  let(:cinema) do
    Movies::Theatre.new(movies) do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
    end
  end

  let(:period) do
    described_class.new('09:00'..'11:00', cinema) do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1990..2000
      price 10
      hall :red, :blue
    end
  end

  describe '#new' do
    subject { period }

    it { is_expected.to have_attributes(filter: { genre: 'Comedy', year: 1990..2000 }) }
    it { is_expected.to have_attributes(cost: 1000) }
    it { is_expected.to have_attributes(halls: cinema.halls) }

    context 'when hall is not found' do
      subject do
        described_class.new('09:00'..'11:00', cinema) do
          description 'Утренний сеанс'
          filters genre: 'Comedy', year: 1900..1980
          price 10
          hall :black
        end
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Зала black нет в кинотеатре')
      end
    end
  end

  context '#tickets' do
    subject { period.tickets }

    it 'returns the number of seats for this show' do
      is_expected.to eq(150)
    end
  end

  context '#to_s' do
    subject { period.to_s }

    it 'returns the show time and hall titles' do
      is_expected.to eq('Утренний сеанс: 09:00 - 11:00, Красный зал, Синий зал')
    end
  end
end
