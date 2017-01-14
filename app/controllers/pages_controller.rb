class PagesController < ApplicationController
  
  def welcome
    @focused = "All"
  end

  def projects
    @focused = "Projects"
    @focused_projects = "All"
  end
end
