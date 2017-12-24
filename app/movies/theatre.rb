module Movies
  class Theatre < Cinema
    include TicketOffice

    SCHEDULE = {
      утром: { period: :ancient },
      днем: { genre: %w[Comedy Action] },
      вечером: { genre: %w[Drama Horror] }
    }.freeze

    TIME_PERIODS = {
      утром: Time.parse('10:00')..Time.parse('13:00'),
      днем: Time.parse('13:00')..Time.parse('19:00'),
      вечером: Time.parse('19:00')..Time.parse('24:00')
    }.freeze

    PRICE = {
      утром: 300,
      днем: 500,
      вечером: 1000
    }.freeze

    def show(time = nil)
      raise 'Укажите желаемое время просмотра фильма' if time.nil?
      start choice schedule_film(time)
    end

    def schedule_film(time)
      period = find_period(time)
      raise 'Кинотеатр закрыт' if period.nil?

      @movies.filter(SCHEDULE[period[0]])
    end

    def buy_ticket(time)
      period = find_period(time)
      raise 'Кинотеатр закрыт' if period.nil?

      movie = choice @movies.filter(SCHEDULE[period[0]])
      put_money PRICE[period[0]]
      puts "Вы купили билет на #{movie.name}"
    end

    def when?(name)
      film = @movies.filter(name: name).first
      raise 'Фильм не найден' if film.nil?

      periods = SCHEDULE.select do |_, condition|
        film.match_all?(condition)
      end.keys

      if periods.empty?
        'Данный фильм не показывают в нашем кинотеатре'
      else
        periods.join(' или ')
      end
    end

    private

    def find_period(time)
      TIME_PERIODS.detect { |_, value| value.include?(Time.parse(time)) }
    end
  end
end
