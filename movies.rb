BAD = ['Titanic', 'The Passage', 'Interstellar', 'The Pianist']
GOOD = ['Matrix', 'The Shawshank Redemption', 'Forrest Gump', 'Leon']

for arg in ARGV
  if GOOD.include?(arg)
    puts "#{arg} is a good movie"
  elsif BAD.include?(arg)
    puts "#{arg} is a bad movie"
  else
    puts "Haven't seen #{arg} yet"
  end
end
