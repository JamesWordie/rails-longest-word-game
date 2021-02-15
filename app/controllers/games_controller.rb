class GamesController < ApplicationController
  require 'open-uri'

  def new
    vowels = %w(A E I O U)
    @letters = Array.new(4) { vowels.sample }
    @letters += Array.new(6) { (('A'..'Z').to_a - vowels).sample }
    @letters.shuffle!
    # @letters = []
    # i = 0
    # until i == 10
    #   @letters << ('A'..'Z').to_a.sample
    #   i += 1
    # end
    # @letters
  end

  def score
    @guess = params[:word].upcase
    @letters = params[:letters].split
    @included = included_letters?(@guess, @letters)
    @english_word = english_word?(@guess)
    session_score(@guess)
    # @result = ''
    # if @included
    #   if @english_word
    #     session_score(@guess)
    #     @result = "Congratulations! #{@guess} is a valid English word."
    #   else
    #     @result = "Sorry but #{@guess} does not seem to be a valid English word..."
    #   end
    # else
    #   @result = "Sorry but #{@guess} can't be built out of #{@letters}"
    # end
  end

  def included_letters?(guess, letters)
    counter = Hash.new(0)
    letters.each { |letter| counter[letter.upcase] += 1 }
    guess.split('').each { |letter| counter[letter.upcase] -= 1 }
    return false if counter.values.any?(&:negative?)

    guess.chars.map { |letter| letters.include? letter }.all?(true)
  end

  def english_word?(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    data = JSON.parse(URI.open(url).read)
    data['found']
  end

  def session_score(guess)
    @total_score = params[:score].to_i
    @total_score += guess.length**2
    params[:score] = @total_score
  end
end
