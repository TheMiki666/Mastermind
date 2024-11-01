# MASTERMIND ARTIFICIAL INTELIGENCE
# Version 1.0.0
#
# The algorithm implemented here is far from optimal. It does solve the secret code, yes; but it takes many turns.
# There are two reasons why this algorithm is not efficient:
# 1. Nobody wants to play against an AI that systematically solves a Mastermind board in five turns;
# for the same reason that nobody plays tic-tac-toe against an artificial intelligence:
# because, mathematically, it is impossible to beat.
# With an inefficient algorithm, there is a chance that the computer will run out of turns before guessing the secret code.
# 2. I am not a mathematician or a software engineer.
# I do not want to enter the deep world of artificial intelligence development right now.
# Right now I am focused on learning how to build web applications, not on algorithms.
# Perhaps, when Project Odin is over, I will review this code and develop a more efficient algorithm.
# For now, I do not want to waste too many days on an exercise whose real objective is to learn how Object Orientation is applied, not algorithms.
#
# My algorithm (which I will call "Miki algorithm" works like this):
# I. PHASE ONE:
# 1. At the start of the game, the AI shuffles the six colors
# 2. One by one, the AI tries secuences of 4 identical colors, until it founds all the colors in the code.
# If in the fifth trial the AI has not gather the 4 colors, it asummes that the chips left are of the sixth color

module Mastermind
  require_relative 'board'

  class ArtificialInteligence
    def initialize(board)
      @board = board
    end

    # TODO: SUSTITUIR LOS 4 POR LA COSTANTE cHIP_PER_ROWS

    # Clears the memory of the AI.
    # Use this method when you start a new game
    def memory_clear
      @phase = 1
      @my_colors = @board.AUTORIZED_COLORS.shuffle
      @dis_chips = '' # the combination of disordered chips
      @combinations = []
      @comb_index = 0 # Index of the next combination on phase 2
    end

    # Returns the next movement (a code to try to guess the secret code)
    def get_movement
      analize_board
      if @phase == 1
        response = String.new(@dis_chips)
        next_color = @my_colors[@board.next_row]
        (@board.CHIPS_PER_ROW - @dis_chips.length).times { response.concat(next_color) }
      elsif @phase == 2
        response = @combinations[@comb_index]
        @comb_index += 1
        @comb_index = 0 if @comb_index >= @combinations.length # This shoud never happens!
      end
      response
    end

    # analizes the board
    def analize_board
      return unless @phase == 1
      return unless @board.turn_number > 1

      color = @board.get_last_row[-1] # We take last chip
      new_chips = @board.get_last_result[1] + @board.get_last_result[0] - @dis_chips.length
      # Number of new "deads" + number of "wounded" - chips the AI already had

      new_chips.times { @dis_chips.concat(color) }

      # if we have reached turn 5, the sixth color is automaticaly deduced
      (4 - @dis_chips.length).times { @dis_chips.concat(@my_colors[-1]) } if @board.turn_number == @my_colors.length
      return unless @dis_chips.length == @board.CHIPS_PER_ROW

      create_combinations
      @phase = 2
    end

    # this rutine creates all the possible combinations of the 4 disordered chips
    # THIS RUTINE ONLY WORKS IF CHIPS_PER_ROW=4
    def create_combinations
      @combinations = []
      (0..@dis_chips.length - 1).each do |i|
        (0..@dis_chips.length - 1).each do |j|
          (0..@dis_chips.length - 1).each do |k|
            (0..@dis_chips.length - 1).each do |l|
              if i != j && i != k && i != l && j != k && j != l && k != l
                @combinations.push(@dis_chips[i].concat(@dis_chips[j]).concat(@dis_chips[k]).concat(@dis_chips[l]))
              end
            end
          end
        end
      end
      @combinations.uniq! # We eliminate the repeated combinations
      # Remove the element that generated the combination if it was already tried
      @combinations.delete_if do |element|
        element == @board.get_last_row
      end
      @combinations.shuffle!
    end
  end
end
