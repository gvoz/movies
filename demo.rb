require_relative 'movie_collection'
filename = "movies.txt"

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts "Введите название файла в кавычках"
  return
end

movies = MovieCollection.new(filename)

puts movies.filter(year: 2001...2008, actors: /Bale/)
