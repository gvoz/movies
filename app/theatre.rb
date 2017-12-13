class Theatre < Cinema
  SCHEDULE = {
    утром: { period: :ancient },
    днем: { genre: ['Comedy', 'Action'] },
    вечером: { genre: ['Drama', 'Horror'] }
  }

  TIME_PERIODS = {
    утром: Time.parse('10:00')..Time.parse('13:00'),
    днем: Time.parse('13:00')..Time.parse('19:00'),
    вечером: Time.parse('19:00')..Time.parse('24:00')
  }

  def show(time = nil)
    raise "Укажите желаемое время просмотра фильма" if time.nil?
    start choice schedule_film(time)
  end

  def schedule_film time
    period = TIME_PERIODS.detect { |key, value| value === Time.parse(time) }
    raise "Кинотеатр закрыт" if period.nil?

    @movies.filter(SCHEDULE[period[0]])
  end

  def when? name
    period = []
    film = @movies.filter(name: name).first
    raise "Фильм не найден" if film.nil?

    periods = SCHEDULE.select do |_, condition|
      film.match_all?(condition)
    end.keys

    if periods.empty?
      'Данный фильм не показывают в нашем кинотеатре'
    else
      periods.join(' или ')
    end
  end
end
