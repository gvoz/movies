module Movies
  class ClassicMovie < Movie
    def to_s
      text = "#{@name} — классический фильм, режиссёр #{@director}"
      text + " (ещё #{@collection.filter(director: @director).size} его фильмов в спике)"
    end
  end
end
