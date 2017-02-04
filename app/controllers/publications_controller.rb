class PublicationsController < ApplicationController
  def index
    @publications = Publication.includes(:authors).includes(:journal).order(:title).paginate(page: params[:page], per_page: 5)
    @focused = "Data"
    @focused_datatype = "Publications"
  end

  def edit
    @focused = "Data"
    @focused_datatype = "Publications"
    @publication = Publication.find(params[:id])
    @publication.display_title = @publication.title
  end

  def update
    @focused = "Data"
    @focused_datatype = "Publications"
    @publication = Publication.find(params[:id])
    @publication.update_attributes(publication_params)
    render :edit
  end

  private

  def publication_params
    params.require(:publication).permit(:publication_year, :display_title)
  end
end
