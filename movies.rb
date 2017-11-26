require 'csv'
require 'ostruct'

filename = "movies.txt"
keys = %i[link name year county date genres duration rating director]

def puts_movies(array)
  array.each{ |a| puts "#{a.name} (#{a.date}; #{a.genres}) - #{a.duration}" }
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

movies = CSV.read(filename, { :col_sep => '|' }).map{ |row| OpenStruct.new(keys.zip(row).to_h) }

puts "5 самых длинных фильмов:"
puts_movies(movies.sort_by{ |movie| movie.duration.to_i}.first(5))

puts "10 комедий (первые по дате выхода):"
puts_movies(movies.select{ |movie| movie.genres.include?('Comedy') }.sort_by{ |movie| movie.date.to_i}.first(10) )

puts "список всех режиссёров по алфавиту"
movies.map{ |movie| movie.director }.uniq.sort_by{ |a| a.split.last }.each{ |a| puts a }

puts "количество фильмов, снятых не в США:"
puts movies.count{ |movie| movie.county != 'USA' }

puts "Статистика по месяцам:"
dates = movies.map{ |movie| Date.strptime(movie.date, '%Y-%m').month if movie.date.size > 4 }.compact
dates.uniq.sort.map{|month| [Date::MONTHNAMES[month], dates.count(month)]}.each{ |a| puts "#{a[0]}: #{a[1]}"}

