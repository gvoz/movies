module Movies
  class Movie
    include Virtus.model

    attribute :link, String
    attribute :name, String
    attribute :country, String
    attribute :date, Date
    attribute :genre, StringToArray
    attribute :year, Integer
    attribute :duration, Float
    attribute :rating, Float
    attribute :director, String
    attribute :actors, StringToArray
    attribute :collection, Object

    def duration=(duration_str)
      super duration_str.to_f
    end

    def genre?(g)
      raise 'Такого жанра нет в коллекции фильмов' unless @collection.genres.include?(g)
      genre.include?(g)
    end

    def county?(c)
      county == c
    end

    def to_s
      "#{@name} (#{@year}, #{@date.strftime('%d.%m.%Y')}, #{@country}," \
      "#{@genre.join(', ')}, #{@duration} min, #{@rating})." \
      "Director: #{@director}. Actors: #{@actors.join(', ')}"
    end

    def match?(key, value)
      exclusion = false
      if key.to_s.split('_').first == 'exclude'
        exclusion = true
        key = key.to_s.split('_').last.to_sym
      end
      raise "В описании фильма нет поля #{key}" unless respond_to?(key)

      exclusion ^ match_result(key, value)
    end

    def match_all?(condition)
      condition.all? { |key, value| match?(key, value) }
    end

    def self.create(params)
      case params[:year].to_i
      when 1900...1945 then AncientMovie.new(params)
      when 1945...1968 then ClassicMovie.new(params)
      when 1968...2000 then ModernMovie.new(params)
      when 2000...Date.today.year then NewMovie.new(params)
      else new(params)
      end
    end

    def period
      self.class.name.scan(/(\w+)Movie/).flatten.first.downcase.to_sym
    end

    private

    def match_result(key, value)
      if key == :genre
        value.is_a?(Array) ? (send(key) & value).any? : send(key).include?(value)
      else
        value === send(key) || value === send(key).to_s
      end
    end
  end
end
