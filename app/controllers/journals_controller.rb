class JournalsController < ApplicationController
  before_action :set_show_values
  before_action :find_journal, only: [:show, :edit, :update]

  def index
    @journals = Journal.order(:name).paginate(page: params[:page], per_page: 15)
  end

  def show
    @publication_count = @journal.articles.count
    @years = @journal.articles.order(publication_year: :desc).group(:publication_year).paginate(page: params[:page], per_page: 80)
  end

  def edit
  end

  def update
    @journal.update_attributes(journal_params)
    redirect_to journal_path
  end

  def year
    @year = params[:year].to_i
    @journal = Journal.find(params[:journal_id])
    @publications = @journal.articles.where(publication_year: @year).paginate(page: params[:page], per_page: 9).order(:title)
  end

  def affinities
    @journal = Journal.find(params[:journal_id])
    @affinities = Affinity.for(@journal).includes(:journal_one).includes(:journal_two).compact.reject{ |a| a.affinity.nan? }.sort_by(&:affinity).reverse
  end

  private

  def find_journal
    @journal = Journal.find(params[:id])
  end

  def set_show_values
    @focused = "Data"
    @focused_datatype = "Journals"
  end

  def journal_params
    params.require(:journal).permit(:name, :publication_start, :publication_end, :display_name)
  end
end