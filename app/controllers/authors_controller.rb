class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name).paginate(page: params[:page])
  end
end
