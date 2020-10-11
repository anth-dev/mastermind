# frozen_string_literal: true

# Add colorful string support.
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

# This class makes Mastermind game objects.
class Mastermind
  attr_reader :secret_code

  def initialize
    @secret_code = generate_random_code
  end

  def generate_random_code
    [pick_a_color, pick_a_color, pick_a_color, pick_a_color]
  end

  def pick_a_color
    case rand(1..7)
    when 1
      '0'.red
    when 2
      '0'.green
    when 3
      '0'.yellow
    when 4
      '0'.blue
    when 5
      '0'.pink
    when 6
      '0'.light_blue
    when 7
      '0'
    end
  end

  def display(spot, feedback)
  puts '-' * 14
  puts "|#{spot[0]}|#{spot[1]}|#{spot[2]}|#{spot[3]}|#{feedback[0]}#{feedback[1]}#{feedback[2]}#{feedback[3]}|"
  puts '-' * 14
  end
end

# Below is a test of the display.
# puts '-' * 14
# puts '|' + '0'.red + '|' + '0'.blue + '|' + '0'.yellow + '|' + '0'.light_blue + '|' + '....' + '|'
# puts '-' * 14

test_game = Mastermind.new
test_game.display(test_game.secret_code, ['.','.','.','.'])