class Movie
  attr_reader :link, :name, :year, :country, :date, :genre, :duration, :rating, :director, :actors

  def initialize collection, args
    @collection = collection
    args.each do |k,v|
      instance_variable_set("@#{k}", v ) unless v.nil?
    end

    @actors = @actors.split(',')
    @genre = @genre.split(',')
    @year = @year.to_i
    @duration = @duration.to_i
    @rating = @rating.to_f

    @date = case @date.count('-')
            when 2
              Date.strptime(@date, '%Y-%m-%d')
            when 1
              Date.strptime(@date, '%Y-%m')
            when 0
              Date.strptime(@date, '%Y')
            end
  end

  def has_genre?(g)
    if @collection.genres.include?(g)
      genre.include?(g)
    else
      raise "Такого жанра нет в коллекции фильмов"
    end
  end

  def county?(c)
    county == c
  end

  def to_s
    "#{@name} (#{@year}, #{@date.strftime('%d.%m.%Y')}, #{@country}, #{@genre.join(', ')}, #{@duration} min, #{@rating}). Director: #{@director}. Actors: #{@actors.join(', ')}"
  end
end
