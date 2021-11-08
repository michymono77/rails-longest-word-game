require "open-uri"
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle[0..9]
  end

  def score
    session[:score] = 0 if session[:score].nil?
    @score = 0
    letters = params[:letters].split(" ")
    answer = params[:word].upcase
    answer_arr = answer.split(//) #  creates ["C", "U", "T"]
    if subset?(answer_arr, letters)
      if english_word?(answer)
        @result = "Congratulations! #{params[:word]} is a valid English word!"
        @score += params[:word].length
        session[:score] += @score
      else
        @result = "#{params[:word]} is not a valid English word."
      end
    else
        @result = "Sorry but #{answer} cannot build with #{letters.each {|letter| letter }}"
    end
  end
  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read #  converting Object into String
    json = JSON.parse(word_serialized)
    json['found']
  end

  def subset?(a, b)
  a.all? {|x| b.include?(x) }
  end
end
