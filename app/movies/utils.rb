# frozen_string_literal: true

class StringToArray < Virtus::Attribute
  def coerce(value)
    value.split(',')
  end
end

class Duration < Virtus::Attribute
  def coerce(value)
    raise 'Продолжительность фильма должна быть в минутах' unless value.to_s =~ /^(\d+) min$/
    value.to_i
  end
end

class Range
  def intersection(other)
    return nil if max <= other.begin || other.max <= self.begin
    [self.begin, other.begin].max..[max, other.max].min
  end
  alias & intersection
end
