require_relative '../app/movies'
Money.use_i18n = false

describe Movies::Theatre do
  let!(:movies) { Movies::MovieCollection.new('spec/data/movies_theatre.txt') }
  let(:theatre) { Movies::Theatre.new(movies) }

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

  context 'buy ticket' do
    subject { -> { theatre.buy_ticket('20:15') } }
    it { is_expected.to change{ theatre.cash }.from('$0.00').to('$10.00') }
    it { is_expected.to output(/The Truman Show/).to_stdout }
  end
end