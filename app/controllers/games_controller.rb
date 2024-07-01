require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    @word = params[:word]
    @grid = params[:grid].chars

    if  valid_word_in_grid?(@word, @grid)
      if english_word?(@word)
        @message = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @message = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but #{@word.upcase} can't be build out of #{@grid.join(', ')}..."
    end
  end

  private

  def valid_word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

end
