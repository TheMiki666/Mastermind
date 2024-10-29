module Mastermind
  require 'colorize'

  class Board
    AUTORIZED_COLORS = %w[R Y B G O P]
    # Red, yellow, blue, green, orange and purple
    CHIPS_PER_ROW = 4
    ROWS_PER_BOARD = 12

    def initialize
      clear
    end

    # TODO: borra este método cuando el programa funcione
    def set_secret_code(code)
      @secret_code = code
    end

    def create_secret_code
      @secret_code = ''
      (0..CHIPS_PER_ROW - 1).each do |chip|
        @secret_code.concat(AUTORIZED_COLORS[rand(AUTORIZED_COLORS.length)])
      end
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

    # Compares the code with the secret code, and return an array with the wounded (W) and the deads (D)
    # For example: [2,1] means two wounded, one dead
    # Returs false if the code is not correct or the secret code is empty
    def compare_code(code)
      return false if !correct_code?(code) || @secret_code == ''

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
        if code[i] == @secret_code[i]
          used[i] = 2 # We cross out both entered code chip and secret code chip
          dead += 1
        end
      end
      # Now we look for woundeds
      (0..CHIPS_PER_ROW - 1).each do |i|
        (0..CHIPS_PER_ROW - 1).each do |j|
          next unless i != j && used[i] != 2 && used[j] == 0 && code[i] == @secret_code[j]

          used[j] = 1 # We cross out only the secret code chip
          wounded += 1
          # We must stop the searchig now! Otherwise we could count another wounded incorrectly
          break
        end
      end
      [wounded, dead]
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
        @result[@next_row] = compare_code(code)
        @next_row += 1
        true
      end
    end

    def clear
      create_secret_code
      @rows = Array.new(12, '')
      @result = Array.new(12, nil)
      @next_row = 0
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

    def draw_board
      if @next_row == 0
        puts 'Board is empty'
      else
        (0..@next_row - 1).each do |i|
          puts "Row #{i > 8 ? '' : '0'}#{i + 1}:#{@rows[i]} => #{@result[i][0]} wounded, #{@result[i][1]} dead"
        end
      end
      puts
    end
  end
end
