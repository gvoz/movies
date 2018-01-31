module Movies
  class CountrySelection
    def initialize(movies)
      @movies = movies
      @countries = @movies.flat_map(&:country).uniq.map { |country| country.downcase.tr(' ', '_') }
    end

    def method_missing(name)
      if valid_name?(name)
        @movies.filter(country: regex(name))
      else
        super
      end
    end

    def respond_to_missing?(name, *)
      valid_name?(name) || super
    end

    private

    def regex(name)
      /#{name.to_s.tr('_', ' ')}/i
    end

    def valid_name?(name)
      @countries.include?(name.to_s)
    end
  end
end
