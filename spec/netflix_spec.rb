require_relative '../movies'

describe Netflix do
  let!(:movies) { MovieCollection.new('spec/data/movies.txt') }
  let(:netflix) { Netflix.new(movies) }

  describe '#show' do
    before { netflix.pay(10) }

    context 'when AncientMovie' do
      subject { -> { netflix.show(period: :ancient) } }
      it { is_expected.to output(/старый фильм/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(10).to(9) }
    end

    context 'when ClassicMovie' do
      subject { -> { netflix.show(period: :classic) } }
      it { is_expected.to output(/классический фильм/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(10).to(8.5) }
    end

    context 'when ModernMovie' do
      subject { -> { netflix.show(period: :modern) } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(10).to(7) }
    end

    context 'when NewMovie' do
      subject { -> { netflix.show(period: :new) } }
      it { is_expected.to output(/новинка/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(10).to(5) }
    end

    context 'when not found' do
      subject { -> { netflix.show(year: 2100) } }
      it { is_expected.to raise_error("Нет подходящих фильмов для просмотра") }
    end
  end

  context '#pay' do
    before { netflix.pay(4) }

    it 'enough money' do
      expect{netflix.pay(10)}.to change{netflix.balance}.from(4).to(14)
    end

    it 'not enough money' do
      expect{netflix.show(period: :new)}.to raise_error('Нужно больше золота')
    end
  end

  context '#how_much?' do
    it 'ancient' do
      expect(netflix.how_much?(movies.filter(year: 1900...1945).first.name)).to eq(1)
    end

    it 'classic' do
      expect(netflix.how_much?(movies.filter(year: 1945...1968).first.name)).to eq(1.5)
    end

    it 'modern' do
      expect(netflix.how_much?(movies.filter(year: 1968...2000).first.name)).to eq(3)
    end

    it 'new' do
      expect(netflix.how_much?(movies.filter(year: 2000...2017).first.name)).to eq(5)
    end

    it 'not found'do
      expect{netflix.how_much?('Abracadabra')}.to raise_error("Фильм не найден")
    end
  end
end
