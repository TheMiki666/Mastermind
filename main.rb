# MASTERMIND GAME
# Version 1.0.0

require_relative 'lib/board'
require_relative 'lib/game_manager'
require_relative 'lib/artificial_inteligence'

my_board = Mastermind::Board.new
ai = Mastermind::ArtificialInteligence.new(my_board)
gm = Mastermind::GameManager.new(my_board, ai)
gm.start_game
