require 'csv'

require_relative 'movie'

class MovieCollection
  FIELDS = %i[link name year country date genre duration rating director actors]
  attr_reader :genres

  def initialize filename
    read_file(filename)
  end

  def read_file filename
    @list = CSV.read(filename, col_sep: '|', headers: FIELDS).map{ |row| Movie.new(self, row.to_h) }
    @genres = @list.map(&:genre).flatten.uniq
  rescue
    puts "Файл #{filename} не найден"
  end

  def all
    @list.map{|m| m.to_s}
  end

  def sort_by(field)
    @list.sort_by(&field).map{|m| m.to_s}
  end

  def filter(params)
    movies = @list
    params.each do |key, value|
      movies = movies.select{ |movie| movie.send(key).include?(value) }
    end
    movies.map{ |m| m.to_s }
  end

  def stats(field)
    @list.map(&field).flatten.sort.group_by(&:itself).transform_values { |v| v.size }
  end

  def inspect
    "<#{self.class}: #{@list.first(5).map{|m| m.to_s}.join("; ")}>"
  end
end
