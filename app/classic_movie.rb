class ClassicMovie < Movie
  def type
    'classic'
  end

  def to_s
    "#{@name} — классический фильм, режиссёр #{@director} (ещё #{@collection.filter(director: @director).size} его фильмов в спике)"
  end
end
