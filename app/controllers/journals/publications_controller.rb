class Journals::PublicationsController < ApplicationController
  before_action :set_show_values
  before_action :find_journal, only: [:index]

  def index
    @years = @journal.articles.order(publication_year: :desc).group(:publication_year).paginate(page: params[:page], per_page: 80)
  end

  def year
    @year = params[:year].to_i
    @journal = Journal.find(params[:journal_id])
    @publications = @journal.articles.where(publication_year: @year).paginate(page: params[:page], per_page: 9).order(:volume, :number, :pages, :title)
  end

  private
  
  def find_journal
    @journal = Journal.find(params[:journal_id])
  end

  def set_show_values
    @focused = "Data"
    @focused_datatype = "Journals"
  end

  def journal_params
    params.require(:journal).permit(:name, :publication_start, :publication_end, :display_name)
  end
end