require_relative 'movie_collection'
filename = "movies.txt"

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts "Введите название файла в кавычках"
  return
end

movies = MovieCollection.new(filename)

puts 'Список фильмов'
puts movies.all

puts 'сортировка по дате'
puts movies.sort_by(:date)

puts 'Список комедий'
puts movies.filter(genre: 'Comedy')

puts 'Список итальянских комедий'
puts movies.filter(genre: 'Comedy', country: 'Italy')

puts 'Статистика режисеров'
puts movies.stats(:director)

puts 'Статистика актеров'
puts movies.stats(:actors)
