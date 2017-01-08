class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name).all
  end
end
