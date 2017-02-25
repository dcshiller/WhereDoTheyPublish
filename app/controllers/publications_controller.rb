class PublicationsController < ApplicationController
  before_action :set_show_values

  def index
    @publications = Publication.includes(:authors).includes(:journal).order(:title).paginate(page: params[:page], per_page: 5)
  end

  def edit
    @publication = Publication.find(params[:id])
    @publication.display_title = @publication.title
  end

  def update
    @publication = Publication.find(params[:id])
    authors = retrieve_authors
    @publication.update_attributes(publication_params)
    @publication.update_attributes(authors: authors) unless authors.blank?
    render :edit
  end

  def destroy
    @publication = Publication.find(params[:id])
    @publication.destroy
  end

  private

  def set_show_values
    @focused = "Data"
    @focused_datatype = "Publications"
  end

  def retrieve_authors
    authors = []
    @publication.authors.count.times do |idx|
      authors << Author.find_by(id: params["author_#{idx}"])
    end
    authors << Author.from_name(params["new_author_1"]) unless params["new_author_1"].blank?
    authors << Author.from_name(params["new_author_2"]) unless params["new_author_2"].blank?
    authors.compact
  end

  def publication_params
    params.require(:publication).permit(:publication_year, :display_title, :publication_type)
  end
end
