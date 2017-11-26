filename = "movies.txt"

if ARGV.size == 1
  filename = ARGV[0]
elsif ARGV.size > 1
  puts "Введите название файла в кавычках"
  return
end

if File.exist?(filename)
  File.open(filename, "r").each do |file|
    puts '*' * (( file.split('|')[7].to_f - 8 ) * 10).round(0) unless file.split('|')[1].scan("Max").empty?
  end
else
  puts "Файл #{filename} не найден"
end

