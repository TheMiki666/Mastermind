# Class GameManager
# version 1.1.0
# The Game Manager controls the flow of the game
# It is the responsible of filtering the inputs of the player
# It says when you win or when the computer wins
# It has two loop games: one for the game when the player is the guesser,
# and other for the game when the AI is the guesser

module Mastermind
  require_relative 'board'

  class GameManager
    def initialize(board, artificial_inteligence)
      @board = board
      @ai = artificial_inteligence
      @normal_game = true # true = player is the guesser, false = AI is the guesser
    end

    def start_game
      greet
      new_match
    end

    private

    def greet
      puts '***********************'.colorize(:blue)
      puts '*Welcome to MASTERMIND*'.colorize(:blue)
      puts '***********************'.colorize(:blue)
      puts
      puts 'In this game you have to guess the secret color combination'
      show_instructions
      puts 'You have 12 tries to guess the combination'
      puts
      print 'Press Enter to continue'
      gets.chomp
    end

    def show_instructions
      puts 'Each combination is a sequence of 4 colors'
      show_short_instructions
      puts 'The computer will compare your code with the secret code'
      puts 'Each '.concat('wounded '.colorize(:grey)).concat('means that a color exists in the secret code but it is not in the correct position')
      puts 'Each '.concat('dead '.colorize(:red)).concat('means that a color exists in the secret code and it is the correct position')
    end

    def show_short_instructions
      puts 'There are six posible colors:'
      puts 'R=Red'.colorize(:red).concat('    Y=Yellow'.colorize(:yellow)).concat('  C=Cyan'.colorize(:cyan))
      puts 'G=Green'.colorize(:green).concat('  B=Blue'.colorize(:blue)).concat('    M=Magenta'.colorize(:magenta))
      puts 'This colors can be repeated two or more times in the same combination'
      puts 'For example; these are correct combinations:'
      puts '"GRCM", "YYBC", "GRGG" or "MMMR"'
      puts '(Type "BREAK" if you want to interrupt the game)'.colorize(:yellow)
    end

    def new_match
      @board.clear
      if ask_for_guesser
        normal_game_loop
      else
        inverse_game_loop
      end
    end

    # Game loop where the guesser is the player
    def normal_game_loop
      show_normal_start_message
      finish_loop = 0 # 0: continue  1: winning  2: full board  3: BREAK
      loop do
        player_code = ask_for_code
        if player_code == 'BREAK'
          finish_loop = 3
          break
        end

        @board.store_code(player_code)
        puts
        @board.draw_board
        if @board.has_won?
          finish_loop = 1
        elsif @board.full_board?
          finish_loop = 2
        end
        break if finish_loop > 0
      end
      case finish_loop
      when 1
        puts 'You have guessed the secret code!'.colorize(:green)
        puts 'You won the game!'.colorize(:green)
        ask_for_another_match
      when 2
        puts 'The board is full and you have not guessed the secret code'.colorize(:red)
        @board.say_secret_code
        puts 'You lost the game!'.colorize(:red)
        ask_for_another_match
      when 3
        finish_game
      end
    end

    # Game loop where the guesser is the AI
    def inverse_game_loop
      @board.clear
      @ai.memory_clear
      return unless ask_for_secret

      loop do
        combination = @ai.get_movement
        puts "The AI tries this combination :#{combination}"
        puts
        @board.store_code(combination)
        @board.draw_board
        break if @board.has_won? || @board.full_board?

        puts 'Press enter to continue'
        gets.chomp
        puts
      end
      if @board.has_won?
        puts 'AI wins!'.colorize(:red)
        puts
      else
        puts "AI couldn't guess the secret code on time!".colorize(:green)
        puts 'You win!'.colorize(:green)
        puts
      end
      ask_for_another_match
    end

    def show_normal_start_message
      puts
      puts "Let's start!"
      puts 'The computer has thought a 4 color combination'
      puts 'Rembember: you have got 12 tries to guess it'
      puts
    end

    # Ends the application
    def finish_game
      puts 'Thank you for playing!'
      puts 'Have a nice day!'
    end

    def ask_for_another_match
      answer = ''
      loop do
        puts 'Do you want another match (y/n)?'
        answer = gets.chomp.downcase
        break if %w[y n].include?(answer)
      end
      if answer == 'y'
        new_match
      else
        finish_game
      end
    end

    # Asks on console if the guesser is the AI or the player
    def ask_for_guesser
      answer = ''
      loop do
        puts
        puts 'What do yo prefer?'
        puts 'Normal game: the computer thinks a code and you try to guess it'
        puts 'Inverse game: you think a code and an AI tries to guess it'
        puts '(N=normal, I=inverse)'
        answer = gets.chomp.downcase
        break if %w[n i].include?(answer)
      end
      puts
      @normal_game = (answer == 'n')
    end

    # Ask for a code on console (normal play)
    def ask_for_code
      answer = ''
      loop do
        if @board.rows_remaining == 1
          puts 'This is the last opportunity!'.colorize(:yellow)
        elsif @board.rows_remaining < 4
          puts "There are only #{@board.rows_remaining} turns remainig!".colorize(:yellow)
        end
        puts "Turn number #{@board.turn_number}:"
        puts 'What is the secret combination?'
        answer = gets.chomp.upcase
        break if answer == 'BREAK' || @board.correct_code?(answer)

        complain
        @board.draw_board
      end
      answer
    end

    # Ask for the secret code on console (inverse game)
    # Returns false if there is a break
    def ask_for_secret
      secret_code = ''
      loop do
        puts 'Please, think of a secret code, and write it'
        secret_code = gets.chomp.upcase
        break if @board.correct_code?(secret_code) || secret_code == 'BREAK'

        complain
      end
      if secret_code == 'BREAK'
        finish_game
        false
      else
        @board.set_secret_code(secret_code)
        puts 'OK. Now the AI will try to guess your code'
        puts 'Press enter to continue'
        gets.chomp
        true
      end
    end

    # Complain to the player if the code inserted on console is not correct
    def complain
      puts 'THAT IS NOT A CORRECT COMBINATION OF COLORS!'.colorize(:red)
      show_short_instructions
      puts
    end
  end
end
