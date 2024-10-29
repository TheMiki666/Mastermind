module Mastermind
  require_relative 'board'

  class GameManager
    def initialize(board)
      @board = board
    end

    def start_game
      greet
      new_match
    end

    private

    def greet
      puts '***********************'
      puts '*Welcome to MASTERMIND*'
      puts '***********************'
      puts
      puts 'In this game you have to guess the secret color combination'
      show_instructions
      puts 'You have 12 tries to guess the combination'
      puts
      print 'Press any key to continue'
      gets.chomp
    end

    def show_instructions
      puts 'Each combination is a sequence of 4 colors'
      puts 'There are six posible colors:'
      puts 'R=Red    Y=Yellow  O=Orange'
      puts 'G=Green  B=Blue    P=Purple'
      puts 'This colors can be repeated two or more times in the same combination'
      puts 'For example; these are correct combinations:'
      puts '"GROP", "YYBO", "GRGG" or "OOOO"'
      puts 'Type "BREAK" if you want to interrupt the game'
    end

    def new_match
      puts "Let's start!"
      puts 'The computer has thought a 4 color combination'
      puts 'Rembember: you have got 12 tries to guess it'
      puts
      @board.clear
      game_loop
    end

    def game_loop
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
        finish_game
      when 2
        puts 'The board is full and you have not guessed the secret code'.colorize(:red)
        puts 'You lost the game!'.colorize(:red)
        finish_game
      when 3
        finish_game
      end
    end

    def finish_game
      puts 'Thank you for playing!'
      puts 'Have a nice day!'
    end

    def ask_for_code
      answer = ''
      loop do
        puts 'What is the secret combination?'
        answer = gets.chomp.upcase
        break if answer == 'BREAK' || @board.correct_code?(answer)

        puts 'THAT IS NOT A CORRECT COMBINATION OF COLORS!'.colorize(:red)
        show_instructions
        puts
        @board.draw_board
      end
      answer
    end
  end
end