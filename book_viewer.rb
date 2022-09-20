require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

get "/" do # declaring a route that matches URL "/"
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/show/:name" do
  params[:name]
end

get "/chapters/:number" do
  @title = params[:number]
  @chapter = File.read("data/chp#{params[:number]}.txt")

  erb :chapter
end

get "/search" do
  search_term = params[:query]
  @all_chapters = (1..12).map do |num|
    File.read("data/chp#{num}.txt")
  end

  @all_chapters.select do |text|
    text.include?(search_term)
  end
end

not_found do
  redirect "/"
end