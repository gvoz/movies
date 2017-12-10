class MovieCollection
  FIELDS = %i[link name year country date genre duration rating director actors]

  def initialize filename
    read_file(filename)
  end

  def read_file filename
    @list = CSV.read(filename, col_sep: '|', headers: FIELDS).map do |row|
      movie_type row.to_h
    end
  rescue
    puts "Файл #{filename} не найден"
  end

  def movie_type movie
    case movie[:year].to_i
    when 1900...1945
      AncientMovie.new(self, movie)
    when 1945...1968
      ClassicMovie.new(self, movie)
    when 1968...2000
      ModernMovie.new(self, movie)
    when 2000...Date.today.year
      NewMovie.new(self, movie)
    else
      Movie.new(self, movie)
    end
  end

  def genres
    @genres ||= @list.flat_map(&:genre).uniq
  end

  def all
    @list
  end

  def sort_by(field)
    @list.sort_by(&field)
  end

  def filter(params)
    params.reduce(@list) do |movies, (key, value)|
      movies.select{ |movie| movie.match?(key, value) }
    end
  end

  def stats(field)
    @list.flat_map(&field).sort.group_by(&:itself).transform_values(&:size)
  end

  def inspect
    "<#{self.class}: #{@list.map{|m| m.to_s}.join("; ")}>"
  end
end
