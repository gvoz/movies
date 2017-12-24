require_relative '../app/movies'
Money.use_i18n = false

describe Movies::Netflix do
  let(:movies) { Movies::MovieCollection.new('spec/data/movies.txt') }
  let(:netflix) { Movies::Netflix.new(movies) }

  context 'all netfflix one ticket office' do
    let(:netflix2) { Movies::Netflix.new(movies) }
    it { expect { netflix.pay(100) }.to change{ Movies::Netflix.cash }.from('$0.00').to('$100.00') }
    it { expect { netflix2.pay(100) }.to change{ Movies::Netflix.cash }.from('$100.00').to('$200.00') }
  end

  describe '#show' do
    before { netflix.pay(10) }

    context 'when AncientMovie' do
      subject { -> { netflix.show(period: :ancient) } }
      it { is_expected.to output(/старый фильм/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(Money.new(1000)).to(Money.new(900)) }
    end

    context 'when ClassicMovie' do
      subject { -> { netflix.show(period: :classic) } }
      it { is_expected.to output(/классический фильм/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(Money.new(1000)).to(Money.new(850)) }
    end

    context 'when ModernMovie' do
      subject { -> { netflix.show(period: :modern) } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(Money.new(1000)).to(Money.new(700)) }
    end

    context 'when NewMovie' do
      subject { -> { netflix.show(period: :new) } }
      it { is_expected.to output(/новинка/).to_stdout }
      it { is_expected.to change{netflix.balance}.from(Money.new(1000)).to(Money.new(500)) }
    end

    context 'when not found' do
      subject { -> { netflix.show(year: 2100) } }
      it { is_expected.to raise_error("Нет подходящих фильмов для просмотра") }
    end
  end

  context '#pay' do
    before { netflix.pay(4) }

    it 'enough money' do
      expect { netflix.pay(10) }.to change{netflix.balance}.from(Money.new(400)).to(Money.new(1400))
    end

    it 'not enough money' do
      expect { netflix.show(period: :new) }.to raise_error("Баланс $4.00, невозможно показать фильм за $5.00")
    end
  end

  context '#how_much?' do
    it 'ancient' do
      expect(netflix.how_much?(movies.filter(year: 1900...1945).first.name)).to eq('$1.00')
    end

    it 'classic' do
      expect(netflix.how_much?(movies.filter(year: 1945...1968).first.name)).to eq('$1.50')
    end

    it 'modern' do
      expect(netflix.how_much?(movies.filter(year: 1968...2000).first.name)).to eq('$3.00')
    end

    it 'new' do
      expect(netflix.how_much?(movies.filter(year: 2000...2017).first.name)).to eq('$5.00')
    end

    it 'not found'do
      expect { netflix.how_much?('Abracadabra') }.to raise_error('Фильм не найден')
    end
  end

  describe 'block' do
    before { netflix.pay(10) }

    context 'given' do
      subject { -> { netflix.show  { |movie| movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > 1990 } } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change { netflix.balance }.from(Money.new(1000)).to(Money.new(700)) }
    end

    context 'define_filter' do
      before { netflix.define_filter(:test)  { |movie| movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > 1990 } }
      subject { -> { netflix.show(test: true) } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change { netflix.balance }.from(Money.new(1000)).to(Money.new(700)) }
    end

    context 'define_filter with params' do
      before { netflix.define_filter(:test)  { |movie, year| movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > year } }
      subject { -> { netflix.show(test: 1990) } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change { netflix.balance }.from(Money.new(1000)).to(Money.new(700)) }
    end

    context 'new filter on define_filter' do
      before { netflix.define_filter(:test)  { |movie, year| movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > year } }
      before { netflix.define_filter(:new_test, from: :test, arg: 1990) }
      subject { -> { netflix.show(new_test: true) } }
      it { is_expected.to output(/современное кино/).to_stdout }
      it { is_expected.to change { netflix.balance }.from(Money.new(1000)).to(Money.new(700)) }
    end

    it 'define_filter without from' do
      expect { netflix.define_filter(:new_test, from: :test, arg: 1990) }.to raise_error('Фильтр test не найден')
    end
  end
end
