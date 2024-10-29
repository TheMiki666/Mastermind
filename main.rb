require_relative 'lib/board'
require_relative 'lib/game_manager'

my_board = Mastermind::Board.new
gm = Mastermind::GameManager.new(my_board)
gm.start_game
