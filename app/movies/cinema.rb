module Movies
  class Cinema
    def initialize(movies)
      @movies = movies
    end

    def start(movie)
      text = "Now showing: #{movie} (#{Time.now.strftime('%H:%M')}"
      puts text + " - #{(Time.now + movie.duration * 60).strftime('%H:%M')})"
    end

    def choice(movies)
      raise 'Нет подходящих фильмов для просмотра' if movies.empty?
      movies.sort_by { |movie| movie.rating * rand }.last
    end
  end
end
