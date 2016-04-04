require 'yaml'

class Hangman
	def initialize
		content = File.open('5desk.txt', 'r') {|file| file.read} #loads dictionary file
		valid_words = content.split.select { |word| word.length.between?(5,12) } # only words 5-12 characters long
		@word = valid_words.sample.downcase.split('') # picks random word, splits into individual characters, check on this later
		@display = Array.new(@word.length, "_")
		@misses = Array.new
		@turns = 6
	end

	#plays the game once
	def play
		result = "Sorry, you lost. The correct word is #{@word.join}"
		while @turns > 0
			display # displays number of letters, misses, turns remaining
			guess # prompts user for letters
			if @display.none? { |i| i == "_" } #winning condition
				result = "#{display.join(' ')}\n Good job, you've won!"
				@turns = 0
			end
		end
		puts result
	end

	# displays current state of game to player
	def display
		@display.each { |i| print i }
		puts "\n"
		puts "Misses: #{@misses.join(', ')}"
		puts "Turns remaining: #{@turns}"
	end

	def guess
		print "Enter letter to guess or save to save game: "
		input = gets.chomp
		puts "\n"
		if input == "save"
			save_game
			puts "Game succesfully saved"
		elsif @word.none? { |w| w == input } # add missed letter to misses array, reduce turn count
			@misses << input
			@turns -= 1
		else
			@word.each_with_index do |letter, i| # add correctly guessed letter to display array
				@display[i] = letter if letter == input
			end
		end
		end
	end

	def load_game
		content = File.open('games/saved.yaml', 'r') { |file| file.read}
		YAML.load(content) # returns a hangman object
	end

	def save_game
		Dir.mkdir('games') unless Dir.exist? 'games'
		filename = 'games.saved.yaml'
		file.open(filename, 'w') do |file|
			file.puts YAML.dump(self)
		end
	end

	def valid_answer(q)
		input = ''
		until input == 'y' || input =='n'
			print q
			input = gets.chomp
		end
		input 
	end

	# main game loop
	puts "\nHangman\n"
	loop do
		input = valid_answer('Do you want to load previously saved game(y/n)?')
		puts "Thank you. You can save your game at any time by typing 'save' "
		game = input == 'y' ? load_game : Hangman.new
		game.play
		input2 = valid_answer('Play another game (y/n)? ')
		break if input2 == 'n'
	end
