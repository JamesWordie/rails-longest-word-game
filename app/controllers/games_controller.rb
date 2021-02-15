class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = []
    i = 0
    until i == 10
      @letters << ('A'..'Z').to_a.sample
      i += 1
    end
    @letters
  end

  def score
    user_guess = params[:word]
    grid = params[:letters].split
    @guess_in_grid = valid_letters?(user_guess, grid)
    @english_word = valid_word?(user_guess)
    @result = ''
    if @guess_in_grid == true && @english_word == true
      @result = "Congratulations! #{user_guess} is a valid English word."
    elsif @guess_in_grid == true && @english_word == false
      @result = "Sorry but #{user_guess} does not seem to be a valid English word..."
    else
      @result = "Sorry but #{user_guess} can't be built out of #{grid}"
    end
  end

  def valid_letters?(guess, letters)
    counter = Hash.new(0)
    letters.each { |letter| counter[letter.upcase] += 1 }
    guess.split('').each { |letter| counter[letter.upcase] -= 1 }
    return false if counter.values.any?(&:negative?)

    valid = guess.upcase.chars.map do |letter|
      letters.include? letter
    end
    valid.all?(true)
  end

  def valid_word?(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    get_word_data = URI.open(url).read
    data = JSON.parse(get_word_data)
    data['found'] == true
  end
end
