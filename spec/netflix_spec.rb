require_relative '../movies'

describe Netflix do
  let!(:movies) { MovieCollection.new('spec/data/movies.txt') }
  let(:netflix) { Netflix.new(movies) }

  context '#show' do
    before { netflix.pay(10) }

    subject(:ancient) { netflix.show(period: :ancient) }
    it 'ancient' do
      expect(ancient).to match /старый фильм/
      expect(netflix.balance).to eq(9)
    end

    subject(:classic) { netflix.show(period: :classic) }
    it 'classic' do
      expect(classic).to match /классический фильм/
      expect(netflix.balance).to eq(8.5)
    end

    subject(:modern) { netflix.show(period: :modern) }
    it 'modern' do
      expect(modern).to match /современное кино/
      expect(netflix.balance).to eq(7)
    end

    subject(:new_film) { netflix.show(period: :new) }
    it 'new' do
      expect(new_film).to match /новинка/
      expect(netflix.balance).to eq(5)
    end

    it 'not found' do
      expect{netflix.show(year: 2100)}.to raise_error("Нет подходящих фильмов для просмотра")
      expect { raise 'test' }.to raise_error('test')
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
