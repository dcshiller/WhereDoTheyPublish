class PublicationsController < ApplicationController
  def index
    @publications = Publication.includes(:authors).includes(:journal).order(:title).paginate(page: params[:page], per_page: 5)
    @focused = "Data"
    @focused_datatype = "Publications"
  end
end
