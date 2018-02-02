require 'pry'
require_relative 'app/movies'
Money.use_i18n = false

filename = 'spec/data/movies_theatre.txt'

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts 'Введите название файла в кавычках'
  return
end

movies = Movies::MovieCollection.new(filename)
theatre =
  Movies::Theatre.new(movies) do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genre: 'Comedy', year: 1900..1980
      price 10
      hall :red, :blue
    end

    period '11:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: %w[Action Drama], year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters year: 1900..1990, exclude_country: 'USA'
      price 30
      hall :green
    end
  end

theatre.show('21:30')
