module Movies
  class NewMovie < Movie
    def to_s
      "#{@name} — новинка, вышло #{DateTime.now.year - @year} лет назад!"
    end
  end
end
