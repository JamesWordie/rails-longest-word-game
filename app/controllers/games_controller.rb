class GamesController < ApplicationController
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
  end
end
