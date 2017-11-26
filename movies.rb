filename = "movies.txt"
movies = []

def puts_movies(array)
  array.each{ |a| puts "#{a[:name]} (#{a[:date]}; #{a[:genres]}) - #{a[:duration]}" }
end

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts "Введите название файла в кавычках"
  return
end

if File.exist?(filename)
  File.open(filename, "r").each do |file|
    array = file.split('|')
    movies << {
      link: array[0],
      name: array[1],
      year: array[2],
      county: array[3],
      date: array[4],
      genres: array[5],
      duration: array[6],
      rating: array[7],
      director: array[8],
      stars: array[9]
    }
  end
else
  puts "Файл #{filename} не найден"
end

puts "5 самых длинных фильмов:"
puts_movies(movies.sort_by{ |movie| movie[:duration].to_i}.reverse[0..4] )

puts "10 комедий (первые по дате выхода):"
puts_movies(movies.select{ |movie| movie[:genres].include?('Comedy') }.sort_by{ |movie| movie[:date].to_i}[0..9] )

puts "список всех режиссёров по алфавиту"
movies.uniq{ |movie| movie[:director] }.sort_by{ |movie| movie[:director].split.last }.each{ |movie| puts movie[:director] }

puts "количество фильмов, снятых не в США:"
puts movies.select{ |movie| movie[:county] != 'USA' }.size
