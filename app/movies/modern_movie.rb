module Movies
  class ModernMovie < Movie
    def to_s
      "#{@name} — современное кино: играют #{@actors.join(', ')}"
    end
  end
end
