class NewMovie < Movie
  def type
    'new'
  end

  def to_s
    "#{@name} — новинка, вышло #{DateTime.now.year - @year} лет назад!"
  end
end
