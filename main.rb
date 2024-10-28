require_relative 'lib/board'

my_board = Mastermind::Board.new
my_board.set_secret_code('RGBP')
my_board.store_code('OOO')
my_board.store_code('OOYYO')
my_board.store_code('Rayos')
my_board.store_code('OOOO')
my_board.store_code('YYYY')
my_board.store_code('RRRR')
my_board.store_code('GGGG')
my_board.store_code('BBBB')
my_board.store_code('PPPP')
puts my_board.full_board?
my_board.store_code('BBRR')
my_board.store_code('PPPG')
my_board.store_code('PRGB')
my_board.store_code('BPRG')
my_board.store_code('GBPR')
my_board.store_code('RGBP')
my_board.store_code('RGBP')
my_board.store_code('RGBP')
my_board.store_code('RGBP')
my_board.draw_board
puts my_board.full_board?

my_board.clear
my_board.draw_board

my_board.store_code('BBYY')
my_board.store_code('PPGG')
my_board.store_code('RR00')
my_board.draw_board
puts my_board.full_board?
