require_relative '../app/movies'

describe Movies::GenreSelection do
  let(:movies) { Movies::MovieCollection.new('spec/data/movies.txt') }
  let(:genres) { %w[Action Comedy Sci-Fi] }

  subject { described_class.new(movies) }

  it { is_expected.to respond_to(:action) }
  it { is_expected.to respond_to(:comedy) }
  it { is_expected.to respond_to(:sci_fi) }
  it { is_expected.to_not respond_to(:opera) }
end
