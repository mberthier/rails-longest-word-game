require 'open-uri'
# require 'json'

class GamesController < ApplicationController
  def new
    letter_array = ('A'..'Z').to_a + ('A'..'Z').to_a
    @letters = letter_array.sample(10)
  end

  def score
    @letters = params[:grid]
    @word = params[:word]
    serialised_game = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    game = JSON.parse(serialised_game)

    if game['found'] && included?(@word.upcase, @letters)
      @score = "#{@word} is a correct word, well done!"
    elsif game['found']
      @score = "#{@word} is not in the grid..."
    else
      @score = "#{@word} is not a correct english word..."
    end
  end

  def included?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end
end
