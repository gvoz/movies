module Movies
  class MovieCollection
    include Enumerable
    FIELDS = %i[link name year country date genre duration rating director actors]

    def initialize filename
      read_file(filename)
    end

    def read_file filename
      @list = CSV.read(filename, col_sep: '|', headers: FIELDS).map do |row|
        Movie.create(row.to_h.merge(collection: self))
      end
    rescue
      puts "Файл #{filename} не найден"
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

    def each(&block)
      @list.each(&block)
    end
  end
end
