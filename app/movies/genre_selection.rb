# frozen_string_literal: true

module Movies
  class GenreSelection
    def initialize(movies)
      movies.genres.each do |genre|
        define_singleton_method genre.downcase.tr('-', '_') do
          movies.filter(genre: genre)
        end
      end
    end
  end
end
