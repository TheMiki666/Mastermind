# Class Board
# Version 1.0.0
# Stores the secret code, the guessing codes tried, compares the codes with the secret code
# (or any two codes), and calculates and stores the results of the comparations
# This class have several getters and setters methods that can be used for the AI
# or the Game Manager

module Mastermind
  require 'colorize'

  class Board
    AUTORIZED_COLORS = %w[R Y B G C M]
    # Red, yellow, blue, green, cyan and magenta
    CHIPS_PER_ROW = 4
    ROWS_PER_BOARD = 12

    attr_reader :next_row

    def initialize
      clear
    end

    # Sets directly the secret code
    def set_secret_code(code)
      @secret_code = code
    end

    # Getters for the AI
    def AUTORIZED_COLORS
      AUTORIZED_COLORS
    end

    def CHIPS_PER_ROW
      CHIPS_PER_ROW
    end

    def rows_remaining
      ROWS_PER_BOARD - @next_row
    end

    def turn_number
      @next_row + 1
    end

    # Returns last row with chips
    # or false if the row is empty
    def get_last_row
      if @next_row == 0
        false
      else
        @rows[@next_row - 1]
      end
    end

    # Returns the result of last row
    # or false if the row is empty
    def get_last_result
      if @next_row == 0
        false
      else
        @result[@next_row - 1]
      end
    end

    def full_board?
      @next_row >= ROWS_PER_BOARD
    end

    def has_won?
      if @next_row == 0
        false
      else
        # We only check the last row; not all of them
        @result[@next_row - 1][1] == CHIPS_PER_ROW
      end
    end

    # Prints on console the secret code
    def say_secret_code
      print 'The secret code was '
      paint_chips(@secret_code)
      puts
    end

    # Returns true if a string is a correct code (4 autorized colors); false otherwise
    def correct_code?(code)
      if code.length != CHIPS_PER_ROW
        false
      else
        response = true
        (0..CHIPS_PER_ROW - 1).each do |i|
          response = false unless AUTORIZED_COLORS.include?(code[i])
        end
        response
      end
    end

    # Compares the code with the secret code (or another code), and return an array with the wounded (W) and the deads (D)
    # For example: [2,1] means two wounded, one dead
    # Returs false if the code or the secret code are not correct
    # This function is also used for the AI to compare two differents codes (not necesary the secret code)
    def compare_code(code, secret_code)
      return false if !correct_code?(code) || !correct_code?(secret_code)

      wounded = 0
      dead = 0
      # This is an array we need to cross out the chip of the entered code or the secret code already used
      # 0 means none entered code and secret code chips used
      # 1 means secret code chip used, but entered code chip not used (wounded)
      # 2 means both entered code and secret code chips used (dead)
      used = Array.new(CHIPS_PER_ROW, 0)
      # First, we scan for the deads
      (0..CHIPS_PER_ROW - 1).each do |i|
        # First, we check if there is a dead
        if code[i] == secret_code[i]
          used[i] = 2 # We cross out both entered code chip and secret code chip
          dead += 1
        end
      end
      # Now we look for woundeds
      (0..CHIPS_PER_ROW - 1).each do |i|
        (0..CHIPS_PER_ROW - 1).each do |j|
          next unless i != j && used[i] != 2 && used[j] == 0 && code[i] == secret_code[j]

          used[j] = 1 # We cross out only the secret code chip
          wounded += 1
          # We must stop the searchig now! Otherwise we could count another wounded incorrectly
          break
        end
      end
      [wounded, dead]
    end

    # Clears the board
    # Use this method when you start a new match
    def clear
      create_secret_code
      @rows = Array.new(12, '')
      @result = Array.new(12, nil)
      @next_row = 0
    end

    # Draws the board on the console
    def draw_board
      if @next_row == 0
        puts 'Board is empty'
      else
        (0..@next_row - 1).each do |i|
          print "Row #{i > 8 ? '' : '0'}#{i + 1}: "
          paint_chips(@rows[i])
          print ' => '
          print "#{@result[i][0]} wounded, ".colorize(:grey)
          puts "#{@result[i][1]} dead".colorize(:red)
        end
      end
      puts
    end

    # This method first check if the code is correct, if the board has a secret code, and if
    # there is a free row
    # In that case, it stores the code and the result of comparation in the next free row
    # Otherwise, it returns false and do nothing
    def store_code(code)
      if @secret_code == '' || full_board? || !correct_code?(code)
        false
      else
        @rows[@next_row] = code
        @result[@next_row] = compare_code(code, @secret_code)
        @next_row += 1
        true
      end
    end

    private

    # Paint the chips with ther correspondent color, and print them on console
    def paint_chips(code)
      color = ''
      (0..CHIPS_PER_ROW - 1).each do |i|
        case code[i]
        when 'C'
          color = :cyan
        when 'M'
          color = :magenta
        when 'R'
          color = :red
        when 'G'
          color = :green
        when 'B'
          color = :blue
        when 'Y'
          color = :yellow
        end
        print code[i].colorize(color)
      end
    end

    # Creates randomly a secret code
    def create_secret_code
      @secret_code = ''
      (0..CHIPS_PER_ROW - 1).each do |chip|
        @secret_code.concat(AUTORIZED_COLORS[rand(AUTORIZED_COLORS.length)])
      end
    end
  end
end
