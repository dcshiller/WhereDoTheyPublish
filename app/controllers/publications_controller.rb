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
    @publication = Publication.find(params[:id])
    authors = retrieve_authors
    @focused = "Data"
    @focused_datatype = "Publications"
    @publication.update_attributes(publication_params)
    @publication.update_attributes(authors: authors)
    render :edit
  end

  def destroy
    @publication = Publication.find(params[:id])
    @publication.destroy
  end

  private

  def retrieve_authors
    authors = []
    @publication.authors.count.times do |idx|
      authors << Author.find_by(id: params["author_#{idx}"])
    end
    authors << Author.from_name(params["new_author_1"]) unless params["new_author_1"].blank?
    authors << Author.from_name(params["new_author_2"]) unless params["new_author_2"].blank?
    authors.reject(&:blank?)
  end

  def publication_params
    params.require(:publication).permit(:publication_year, :display_title, :publication_type)
  end
end
