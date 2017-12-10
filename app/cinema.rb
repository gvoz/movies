class Cinema
  PERIOD = {:ancient => 1900...1945, classic: 1945...1968, modern: 1968...2000, new: 2000...2100 }

  def initialize movies
    @movies = movies
  end

  def start movie
    "Now showing: #{movie} (#{Time.now.strftime('%H:%M')} - #{(Time.now + movie.duration * 60).strftime('%H:%M')})"
  end

  def choice movies
    raise "Нет подходящих фильмов для просмотра" if movies.empty?
    movies.sort_by{ |movie| movie.rating * rand }.last
  end

  def filter params
    if params.has_key?(:period)
      params[:year] = PERIOD[params[:period]]
      params.delete(:period)
    end
    @movies.filter params
  end
end

