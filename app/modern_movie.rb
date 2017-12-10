class ModernMovie < Movie
  def type
    'modern'
  end

  def to_s
    "#{@name} — современное кино: играют #{@actors.join(', ')}"
  end
end
