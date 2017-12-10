class Theatre < Cinema
  def show(time = nil)
    start choice time.nil? ? @movies.all : schedule_film(time.hour)
  end

  def schedule_film hour
    case hour
    when 10...13
      @movies.filter(year: PERIOD[:ancient])
    when 13...19
      @movies.filter(genre: ['Comedy', 'Action'])
    when 19...24
      @movies.filter(genre: ['Drama', 'Horror'])
    else
      raise "Кинотеатр закрыт"
    end
  end

  def when? name
    film = filter(name: name).first
    raise "Фильм не найден" if film.nil?
    if film.type == 'ancient'
      'Фильм можно посмотреть с 10:00 до 13:00'
    elsif !(['Comedy', 'Action'] & film.genre).empty?
      'Фильм можно посмотреть с 13:00 до 19:00'
    elsif !(['Drama', 'Horror'] & film.genre).empty?
      'Фильм можно посмотреть с 19:00 до 24:00'
    else
      'Данный фильм не показывают в нашем кинотеатре'
    end
  end
end
