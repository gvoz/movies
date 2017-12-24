require 'pry'
require_relative 'app/movies'
Money.use_i18n = false

filename = 'spec/data/movies.txt'

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts 'Введите название файла в кавычках'
  return
end

movies = Movies::MovieCollection.new(filename)
netflix = Movies::Netflix.new(movies)
netflix.pay(10)
netflix.define_filter(:test) do |movie, year|
  movie.name.include?('Terminator') && movie.genre.include?('Action') && movie.year > year
end
netflix.show(test: 1980)
netflix.define_filter(:new_test, from: :test, arg: 1990)
netflix.show(new_test: true)
netflix.show { |movie| movie.actors.include?('Linda Hamilton') && movie.genre.include?('Sci-Fi') }
