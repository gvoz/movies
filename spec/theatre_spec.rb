require_relative '../app/movies'
Money.use_i18n = false

describe Movies::Theatre do
  let!(:movies) { Movies::MovieCollection.new('spec/data/movies_theatre.txt') }
  let(:theatre) do
    Movies::Theatre.new(movies) do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '09:00'..'11:00' do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red, :green
      end

      period '11:00'..'16:00' do
        description 'Спецпоказ'
        title 'The Wizard of Oz'
        price 50
        hall :blue
      end

      period '16:00'..'20:00' do
        description 'Вечерний сеанс'
        filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
        price 20
        hall :red, :blue
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        filters year: 1900..1990, exclude_country: 'USA'
        price 30
        hall :green
      end
    end
  end

  describe '#new' do
    context 'when schedule is invalid' do
      subject do
        Movies::Theatre.new(movies) do
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12
          period '16:00'..'20:00' do
            description 'Вечерний сеанс'
            filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
            price 20
            hall :green, :blue
          end

          period '19:00'..'22:00' do
            description 'Вечерний сеанс для киноманов'
            filters year: 1900..1945, exclude_country: 'USA'
            price 30
            hall :green
          end
        end
      end

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /Расписание некорректно/)
      end
    end

    context 'when schedule is valid' do
      it "doesn't raise an error" do
        expect { theatre }.to_not raise_error
      end
    end
  end

  context '#show' do
    it 'by film name' do
      expect { theatre.show('11:30') }.to output(/The Wizard of Oz/).to_stdout
    end

    it 'by filter' do
      expect { theatre.show('17:30') }.to output(/Inglourious Basterds/).to_stdout
    end

    it 'by exclude filter' do
      expect { theatre.show('21:30') }.to output(/A Fistful of Dollars/).to_stdout
    end

    it 'without time'do
      expect { theatre.show }.to raise_error("Укажите желаемое время просмотра фильма")
    end
  end

  it '#when' do
    expect(theatre.when?('City Lights')).to eq('Утренний сеанс: 09:00 - 11:00, Красный зал, Зелёный зал (deluxe)')
    expect(theatre.when?('The Wizard of Oz')).to eq('Спецпоказ: 11:00 - 16:00, Синий зал')
    expect(theatre.when?('Inglourious Basterds')).to eq('Вечерний сеанс: 16:00 - 20:00, Красный зал, Синий зал')
    expect(theatre.when?('A Fistful of Dollars'))
      .to eq('Вечерний сеанс для киноманов: 19:00 - 22:00, Зелёный зал (deluxe)')
    expect(theatre.when?('The Terminator')).to eq('Данный фильм не показывают в нашем кинотеатре')
  end

  context 'buy ticket' do
    subject { -> { theatre.buy_ticket('20:15') } }
    it { is_expected.to change{ theatre.cash }.from('$0.00').to('$30.00') }
    it { is_expected.to output(/Вы купили билет на A Fistful of Dollars в Зелёный зал/).to_stdout }
  end
end
