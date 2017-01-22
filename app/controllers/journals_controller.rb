class JournalsController < ApplicationController
  def index
    @journals = Journal.order(:name).paginate(page: params[:page], per_page: 15)
    @focused = "Data"
    @focused_datatype = "Journals"
  end

  def show
    @journal = Journal.find(params[:id])
    @publication_count = @journal.publications.count
    @years = @journal.publications.order(publication_year: :desc).group(:publication_year).paginate(page: params[:page], per_page: 80)
    @focused = "Data"
    @focused_datatype = "Journals"
  end

  def year
    @year = params[:year].to_i
    @journal = Journal.find(params[:journal_id])
    @publications = @journal.publications.where(publication_year: @year).paginate(page: params[:page], per_page: 9).order(:title)
    @focused = "Data"
    @focused_datatype = "Journals"
  end
end