filename = "movies.txt"
keys = [:link, :name, :year, :county, :date, :genres, :duration, :rating, :director]

def puts_movies(array)
  array.each{ |a| puts "#{a[:name]} (#{a[:date]}; #{a[:genres]}) - #{a[:duration]}" }
end

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts "Введите название файла в кавычках"
  return
end

unless File.exist?(filename)
  puts "Файл #{filename} не найден"
  return
end

movies = File.open(filename, "r").map{ |file| keys.zip(file.split('|')).to_h }

puts "5 самых длинных фильмов:"
puts_movies(movies.sort_by{ |movie| movie[:duration].to_i}.first(5))

puts "10 комедий (первые по дате выхода):"
puts_movies(movies.select{ |movie| movie[:genres].include?('Comedy') }.sort_by{ |movie| movie[:date].to_i}.first(10) )

puts "список всех режиссёров по алфавиту"
movies.map{ |movie| movie[:director] }.uniq.sort_by{ |a| a.split.last }.each{ |a| puts a }

puts "количество фильмов, снятых не в США:"
puts movies.count{ |movie| movie[:county] != 'USA' }
