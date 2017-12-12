class Theatre < Cinema
  SCHEDULE = {
    утром: { period: :ancient },
    днем: { genre: ['Comedy', 'Action'] },
    вечером: { genre: ['Drama', 'Horror'] }
  }

  TIME_PERIODS = {
    утром: Time.parse('10:00')..Time.parse('12:59'),
    днем: Time.parse('13:00')..Time.parse('18:59'),
    вечером: Time.parse('19:00')..Time.parse('23:59')
  }

  def show(time = nil)
    start choice time.nil? ? @movies.all : schedule_film(time)
  end

  def schedule_film time
    period = TIME_PERIODS.select { |key, value| value === Time.parse(time) }.keys.first
    raise "Кинотеатр закрыт" if period.nil?

    @movies.filter(SCHEDULE[period])
  end

  def when? name
    period = []
    film = @movies.filter(name: name).first
    raise "Фильм не найден" if film.nil?

    periods = SCHEDULE.select do |_, condition|
      @movies.filter(condition).include?(film)
    end.keys

    if periods.empty?
      'Данный фильм не показывают в нашем кинотеатре'
    else
      periods.join(' или ')
    end
  end
end
