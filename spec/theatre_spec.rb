require_relative '../movies'

describe Theatre do
  let!(:movies) { MovieCollection.new('spec/data/movies_theatre.txt') }
  let(:theatre) { Theatre.new(movies) }

  context '#show' do
    it 'morning'do
      expect { theatre.show('11:15') }.to output(/The Wizard of Oz/).to_stdout
    end

    it 'day'do
      expect{ theatre.show('15:15') }.to output(/Pirates of the Caribbean: The Curse of the Black Pearl/).to_stdout
    end

    it 'evening'do
      expect { theatre.show('20:15') }.to output(/The Truman Show/).to_stdout
    end

    it 'mot_work'do
      expect { theatre.show('05:15') }.to raise_error("Кинотеатр закрыт")
    end

    it 'without time'do
      expect { theatre.show }.to raise_error("Укажите желаемое время просмотра фильма")
    end
  end

  context '#when' do
    it 'ancient'do
      expect(theatre.when?('The Wizard of Oz')).to eq('утром')
    end

    it 'classic'do
      expect(theatre.when?('Pirates of the Caribbean: The Curse of the Black Pearl')).to eq('днем')
    end

    it 'modern'do
      expect(theatre.when?('The Truman Show')).to eq('вечером')
    end

    it 'not show'do
      expect(theatre.when?('Notorious')).to eq('Данный фильм не показывают в нашем кинотеатре')
    end

    it 'not found'do
      expect{theatre.when?('Abracadabra')}.to raise_error("Фильм не найден")
    end
  end
end
