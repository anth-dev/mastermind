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
    @secret_code = ['0'.red, '0'.green, '0'.yellow, '0'.blue]
    # @secret_code = generate_random_code
    @current_guess = [' ', ' ', ' ', ' ']
    @guess_history = []
    @current_feedback = [' ', ' ', ' ', ' ']
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
    #   - make instance variable to hold current feedback (or use method scope)
    #   - after the completed guess array has been made duplicate it and the secret
    #     code array and iterate over the duplicated guess array
    #     - after iterating over it and placing red feedback pegs iterate over
    #       the guess array and do the same but checking for colors in the wrong
    #       place *starting on*

    # For each of the four spots have the player input their choice and add
    # their choice to the current guess array.
    4.times do |i|
      display(@current_guess)
      puts '>'
      @current_guess[i] = handle_selection
    end

    # Check to see if they cracked the code!
    check_for_win

    # Generate feedback to display to the player.
    generate_feedback

    # After their guess has been made add it to the guess history.
    @guess_history.push(@current_guess)
    @current_guess = [' ', ' ', ' ', ' ']

    # Add the generated feedback to the feedback history.
    @feedback_history.push(@current_feedback)
    @current_feedback = [' ', ' ', ' ', ' ']

    # Increment the number of guesses.
    @number_of_guesses += 1
  end

  def generate_feedback
    # Clone the arrays we will be checking.
    guess = @current_guess.clone
    secret = @secret_code.clone

    # Use a variable to track where at we are in the current feedback
    # array.
    feedback_index = 0

    # Check each guess element for correct color & placement.
    guess.each_with_index do |element, index|
      # If it is the correct color in the correct spot, 
      if element == secret[index]
        # Select current element in the feedback array using feedback_index as
        # the index and set it to a red '.'.
        @current_feedback[feedback_index] = '.'.red
        
        # Replace the element in secret with nil.
        secret[index] = nil

        # Replace the element in guess with nil.
        guess[index] = nil

        # Increment the feedback_index variable.
        feedback_index += 1
      end
    end
    # Check for correct color in wrong place

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
