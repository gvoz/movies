class Movie
  attr_reader :link, :name, :year, :country, :date, :genre, :duration, :rating, :director, :actors, :collection

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v ) unless v.nil?
    end
    correction_values
  end

  def correction_values
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
    raise "Такого жанра нет в коллекции фильмов" unless @collection.genres.include?(g)
    genre.include?(g)
  end

  def county?(c)
    county == c
  end

  def to_s
    "#{@name} (#{@year}, #{@date.strftime('%d.%m.%Y')}, #{@country}, #{@genre.join(', ')}, #{@duration} min, #{@rating}). Director: #{@director}. Actors: #{@actors.join(', ')}"
  end

  def match? key, value
    raise "В описании фильма нет поля #{key}" unless self.respond_to?(key)

    if key == :genre
      value.is_a?(Array) ? !(send(key) & value).empty? : send(key).include?(value)
    else
      value === send(key) || value === send(key).to_s
    end
  end

  def match_all? condition
    condition.inject(false) { |fit, (key, value)| fit || self.match?(key, value) }
  end

  def self.create params
    case params[:year].to_i
    when 1900...1945
      AncientMovie.new(params) #.merge(period: :ancient))
    when 1945...1968
      ClassicMovie.new(params) #.merge(period: :classic))
    when 1968...2000
      ModernMovie.new(params) #.merge(period: :modern))
    when 2000...Date.today.year
      NewMovie.new(params) #.merge(period: :new))
    else
      self.new(params)
    end
  end

  def period
    self.class.name.split('Movie').first.downcase.to_sym
  end
end
