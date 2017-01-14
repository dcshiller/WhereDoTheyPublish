class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name).paginate(page: params[:page], per_page: 10)
    @focused = "Data"
    @focused_datatype = "Authors"
  end

  def show
    @author = Author.find(params[:id])
    @publications = @author.publications.paginate(page: params[:page], per_page: 10)
  end

end
