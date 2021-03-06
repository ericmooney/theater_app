# == Schema Information
#
# Table name: movies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Movie do
  it "gets created" do
    movie = Movie.new(:name => "Titanic")
    movie.save

    movies = Movie.all
    expect(movies).to include(movie)
  end

  it "gets created without a name" do
    movie = Movie.new

    expect(movie.valid?).to be_false
  end


  it "has many showtimes" do
    movie = FactoryGirl.create(:movie)
    showtime = FactoryGirl.create(:showtime, :movie_id => movie.id)

    expect(movie.poster).to_not be_nil
    expect(movie.showtimes).to include(showtime)
  end
end
