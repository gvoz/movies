module Movies
  class AncientMovie < Movie
    def to_s
      "#{@name} — старый фильм (#{@year} год)"
    end
  end
end
