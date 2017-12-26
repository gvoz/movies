module Movies
  class NewMovie < Movie
    def to_s
      "#{@name} — новинка, вышло #{Time.now.year - @year} лет назад!"
    end
  end
end
