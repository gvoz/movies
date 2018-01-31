require_relative '../app/movies'

describe Movies::CountrySelection do
  let(:movies) { Movies::MovieCollection.new('spec/data/movies.txt') }
  let(:selection) { described_class.new(movies) }

  context 'when movies from the country are in collection' do
    it 'returns a list of movies' do
      expect(selection.italy).to eq(movies.filter(country: 'Italy'))
    end

    it 'can work with double names' do
      expect(selection.west_germany).to eq(movies.filter(country: 'West Germany'))
    end
  end

  context 'when the country is unknown' do
    subject { selection.russia }

    it 'raise error' do
      expect { subject }.to raise_error(NoMethodError)
    end
  end
end
