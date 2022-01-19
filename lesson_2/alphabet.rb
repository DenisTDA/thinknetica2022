# Заполнить хеш гласными буквами, 
#где значением будет являтся порядковый 
#номер буквы в алфавите (a - 1).

alphabet = 'a'..'z'
vowels = %w(e y u i o a)
hash_vowels = {}
alphabet.each.with_index(1) {|char, index| hash_vowels[char] = index if vowels.include?(char)}
puts hash_vowels