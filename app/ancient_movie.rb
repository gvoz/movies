class AncientMovie < Movie
  def type
    'ancient'
  end

  def to_s
    "#{@name} — старый фильм (#{@year} год)"
  end
end
