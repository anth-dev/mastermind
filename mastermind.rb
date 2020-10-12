# frozen_string_literal: true

require 'pry'

# This class adds support for colorful strings.
class String
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

  def initialize
    @secret_code = generate_random_code
    @current_guess = [' ', ' ', ' ', ' ']
    @guess_history = []
    @feedback_history = []
    @number_of_guesses = 1
    @solved = false
  end

  def start
    while @number_of_guesses <= 12
      take_turn
    end
    puts "You lose! You're out of turns."
  end

  private

  def take_turn
    # FIXME: After all 4 choices have been made feedback needs to be calculated
    #   to be displayed to the player and saved to the feedback history array.
    #   - make instance variable to hold current feedback
    #   - after the completed guess array has been made duplicate the secret code
    #     array and iterate over the completed guess.
    #     - for each element of the guess array first check if it is both the
    #       correct color and in the correct place. If so then push '.'.red to
    #       the feedback array and either remove or replace the corresponding
    #       element from the duplicated secret code array. If the check came
    #       back false instead check if that color is contained 

    # note ^^^^^ check rules to see if all the black pegs need to be placed first
    # can it be messed up if they aren't placed in the right order????

    # For each of the four spots have the player input their choice and add
    # their choice to the current guess array.
    4.times do |i|
      display(@current_guess)
      puts '>'
      @current_guess[i] = handle_selection
    end

    # Check to see if they cracked the code!
    check_for_win

    # After their guess has been made add it to the guess history.
    @guess_history.push(@current_guess)
    @current_guess = [' ', ' ', ' ', ' ']

    # Increment the number of guesses.
    @number_of_guesses += 1
  end

  def check_for_win
    return unless @current_guess == @secret_code

    puts "You win!"
    exit
  end

  def handle_selection
    selection = gets.chomp
    case selection
    when '1'
      '0'.red
    when '2'
      '0'.green
    when '3'
      '0'.yellow
    when '4'
      '0'.blue
    when '5'
      '0'.pink
    when '6'
      '0'.light_blue
    when '7'
      ' '
    else
      handle_selection
    end
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
      ' '
    end
  end

  def display(display_array = [' ', ' ', ' ', ' '], feedback_array = [' ', ' ', ' ', ' '])
    # Display the guess history and gameboard.
    system 'clear'
    display_history
    puts '-' * 14
    puts "|#{display_array[0]}|#{display_array[1]}|#{display_array[2]}|#{display_array[3]}|#{feedback_array[0]}#{feedback_array[1]}#{feedback_array[2]}#{feedback_array[3]}| Guess: #{@number_of_guesses}"
    puts '-' * 14

    # List the selection options for the player.
    puts "#{'1'.red} #{'2'.green} #{'3'.yellow} #{'4'.blue} #{'5'.pink} #{'6'.light_blue} 7 is empty"
  end

  def display_history
    @guess_history.each_with_index do |v, i|
      puts "|#{v[0]}|#{v[1]}|#{v[2]}|#{v[3]}|#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][0]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][1]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][2]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][3]}|"
    end
  end
end

system 'clear'
puts '~' * 22
puts 'Welcome to Mastermind!'
puts '~' * 22
puts ''
puts 'Colors may be repeated and blank spaces are allowed.'
puts 'Press enter to continue.'
gets

game = Mastermind.new
game.start
