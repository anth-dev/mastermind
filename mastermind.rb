# frozen_string_literal: true

# This module handles displaying the game interface to the screen.
module Displayable
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

  # Display the guess history along with feedback on choices.
  def display_history
    @guess_history.each_with_index do |v, i|
      puts "|#{v[0]}|#{v[1]}|#{v[2]}|#{v[3]}|#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][0]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][1]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][2]}#{@feedback_history[i].nil? ? ' ' : @feedback_history[i][3]}|"
    end
  end
end

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
  include Displayable
  def initialize
    @secret_code = generate_random_code
    @current_guess = [' ', ' ', ' ', ' ']
    @guess_history = []
    @current_feedback = [' ', ' ', ' ', ' ']
    @feedback_history = []
    @number_of_guesses = 1
  end

  def start_codebreaker
    take_turn while @number_of_guesses <= 12
    puts "You lose! You're out of turns."
  end

  def start_codemaker
    # Clear the secret code generated when the game object was generated.
    @secret_code = [' ', ' ', ' ', ' ']

    # Have the player input a secret code.
    input_secret_code

    # Give the computer 12 guesses to randomly guess what the code is.
    computer_turn while @number_of_guesses <= 12
    puts 'You win! The computer ran out of turns.'
  end

  def start_local_multiplayer
    system 'clear'

    # Prompt for the codebreaker not to look and for the codemaker to input the
    # secret code.
    puts 'Codebreaker - Please leave the room while the Codemaker selects the secret code'
    puts 'Press enter to continue.'
    gets

    # Have the player input a secret code.
    input_secret_code

    # Start the codebreaker game.
    start_codebreaker
  end

  private

  def computer_turn
    # Have the computer take a guess
    @current_guess = generate_random_code

    # Display the guess
    display(@current_guess)

    # Check for a computer win.
    check_for_codemaker_loss(@current_guess)

    # Generate feedback to display about the computer's guesses.
    generate_feedback

    # Add the computer's guess to the guess history.
    @guess_history.push(@current_guess)

    # Add the generated feedback to the feedback history.
    @feedback_history.push(@current_feedback)
    @current_feedback = [' ', ' ', ' ', ' ']

    # Increment the number of guesses.
    @number_of_guesses += 1
  end

  def take_turn
    # For each of the four spots have the player input their choice and add
    # their choice to the current guess array.
    4.times do |i|
      display(@current_guess)
      puts '>'
      @current_guess[i] = handle_selection
    end

    # Check to see if they cracked the code!
    check_for_codebreaker_win

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
      next unless element == secret[index]

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

    # Check for correct color in wrong place
    guess.each_with_index do |element, index|
      # Check each guess element to see if it matches any color remaining
      # in the secret array. Make sure to skip any nil elements that maybe
      # have been introduced when checking for color and placement.
      next unless secret.include?(element) && !element.nil?

      # Select the current element in the feedback array using feedback_index
      # and set it to a '.'.
      @current_feedback[feedback_index] = '.'

      # Find the index of the element in secret.
      secret_index = secret.index(element)

      # Replace the element in secret with nil.
      secret[secret_index] = nil

      # Replace the element in guess with nil.
      guess[index] = nil

      # Increment the feedbad_index variable.
      feedback_index += 1
    end
  end

  def check_for_codemaker_loss(computer_guess)
    return unless computer_guess == @secret_code

    puts 'You lose! The computer guessed your code.'
    # Display winning code.
    puts "|#{@current_guess[0]}|#{@current_guess[1]}|#{@current_guess[2]}|#{@current_guess[3]}|"
    exit
  end

  def check_for_codebreaker_win
    return unless @current_guess == @secret_code

    puts "You win! You guessed the Codemaker's code"
    # Display winning code.
    puts "|#{@current_guess[0]}|#{@current_guess[1]}|#{@current_guess[2]}|#{@current_guess[3]}|"
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

  def input_secret_code
    # Clear any currently set secret code so the display doesn't get confused.
    @secret_code = [' ', ' ', ' ', ' ']
    4.times do |i|
      display(@secret_code)
      puts '>'
      @secret_code[i] = handle_selection
    end
  end
end

# TODO: Add a 2 player mode where one human picks the code and another tries
#   to crack the code. (not a requirement of project)

def display_main_menu
  system 'clear'
  puts '~' * 22
  puts 'Welcome to Mastermind!'
  puts '~' * 22
  puts ''
  puts 'Colors may be repeated and blank spaces are allowed.'
  puts 'Enter your choice to continue.'
  puts '1. Single Player - Codebreaker'
  puts '2. Single Player - Codemaker'
  puts '3. Local Multiplayer'
  puts '4. Exit'
  puts '>'
end

def handle_main_menu(game)
  display_main_menu
  selection = gets.chomp
  case selection
  when '1'
    game.start_codebreaker
  when '2'
    game.start_codemaker
  when '3'
    game.start_local_multiplayer
  when '4'
    exit
  else
    display_main_menu
    handle_main_menu(game)
  end
end

game = Mastermind.new
handle_main_menu(game)
