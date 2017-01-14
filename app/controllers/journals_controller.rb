class JournalsController < ApplicationController
  def index
    @journals = Journal.order(:name).paginate(page: params[:page], per_page: 20)
    @focused = "Data"
    @focused_datatype = "Journals"
  end

  def show
    @journal = Journal.find(params[:id])
    @publications = @journal.publications.order(:publication_year).paginate(page: params[:page], per_page: 20)
    @focused = "Data"
    @focused_datatype = "Journals"
  end
end