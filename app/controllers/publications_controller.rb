class PublicationsController < ApplicationController
  include ApplicationHelper
  before_action :set_show_values

  def index
    @search_string = params[:title]
    @publications = @search_string ? Publication.articles.where("COALESCE(display_title, title) LIKE ?", "%#{@search_string&.split(" ")&.join("%")}%").includes(:authors).includes(:journal).order(:title).paginate(page: params[:page], per_page: 5) : []
    @none_found = true if @search_string && !@publications.exists?
  end

  def show
    @publication = Publication.find(params[:id])
    sift_categories(@publication)
  end

  def new
    @publication = Publication.new(publication_params)
  end

  def create
    attribute_values = publication_params
    @publication = Publication.create(attribute_values)
    authors = retrieve_authors
    @publication.update(authors: authors) unless authors.blank?
    authors.each { |author| CategoryReconciler.reconcile(@publication, author.cat) }
    CategoryReconciler.reconcile(@publication, @publication.journal.cat)
    redirect_to year_journal_publications_path(@publication.journal, @publication.publication_year)
  end

  def edit
    @publication = Publication.find(params[:id])
    @publication.display_title = @publication.display_title || @publication.title
  end

  def update
    @publication = Publication.find(params[:id])
    authors = retrieve_authors
    @publication.update_attributes(publication_params)
    @publication.update_attributes(authors: authors) unless authors.blank?
    redirect_to year_journal_publications_path(@publication.journal, @publication.publication_year)
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
    params[:publication].permit(:publication_year, :title, :display_title, :publication_type, :volume, :number, :pages, :journal_id)
  end
end
