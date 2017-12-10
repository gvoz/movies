require_relative '../movies'

describe Theatre do
  let!(:movies) { MovieCollection.new('spec/data/movies_theatre.txt') }
  let(:theatre) { Theatre.new(movies) }

  context '#show' do
    it 'morning'do
      expect(theatre.show(Time.utc(2017,"dec",10,11,15,1))).to match /The Wizard of Oz/
    end

    it 'day'do
      expect(theatre.show(Time.utc(2017,"dec",10,15,15,1))).to match /Pirates of the Caribbean: The Curse of the Black Pearl/
    end

    it 'evening'do
      expect(theatre.show(Time.utc(2017,"dec",10,20,15,1))).to match /The Truman Show/
    end

    it 'mot_work'do
      expect{theatre.show(Time.utc(2017,"dec",10,05,15,1))}.to raise_error("Кинотеатр закрыт")
    end
  end

  context '#when' do
    it 'ancient'do
      expect(theatre.when?('The Wizard of Oz')).to eq('Фильм можно посмотреть с 10:00 до 13:00')
    end

    it 'classic'do
      expect(theatre.when?('Pirates of the Caribbean: The Curse of the Black Pearl')).to eq('Фильм можно посмотреть с 13:00 до 19:00')
    end

    it 'modern'do
      expect(theatre.when?('The Truman Show')).to eq('Фильм можно посмотреть с 19:00 до 24:00')
    end

    it 'not show'do
      expect(theatre.when?('Notorious')).to eq('Данный фильм не показывают в нашем кинотеатре')
    end

    it 'not found'do
      expect{theatre.when?('Abracadabra')}.to raise_error("Фильм не найден")
    end
  end
end
