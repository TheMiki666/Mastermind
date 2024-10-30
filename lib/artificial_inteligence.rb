module Mastermind
  require_relative 'board'

  class ArtificialInteligence
    def initialize(board)
      @board = board
    end

    # Clears the memory of the AI.
    # Use this method when you start a new game
    def memory_clear
    end

    # Returns the next movement (a code to try to guess the secret cod)
    def get_movement
      'GGGG' # TODO: Change this dummy method for a true logic
    end
  end
end
