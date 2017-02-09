class PagesController < ApplicationController
  def welcome
  end

  def about
    @focused = "About"
  end
end
