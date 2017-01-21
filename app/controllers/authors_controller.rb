class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name).paginate(page: params[:page], per_page: 10)
    @focused = "Data"
    @focused_datatype = "Authors"
  end

  def show
    @focused = "Data"
    @focused_datatype = "Authors"
    @author = Author.find(params[:id])
    @publications = @author.publications.paginate(page: params[:page], per_page: 10).order(:publication_year)
  end
end
