class JournalsController < ApplicationController
  before_action :set_show_values
  before_action :find_journal, only: [:show, :edit, :update]

  def index
    @journals = Journal.order(:name).paginate(page: params[:page], per_page: 15)
  end

  def show
    @publication_count = @journal.publications.count
    @years = @journal.publications.order(publication_year: :desc).group(:publication_year).paginate(page: params[:page], per_page: 80)
  end

  def edit
  end

  def update
    @journal.update_attributes(journal_params)
    render :show
  end

  def year
    @year = params[:year].to_i
    @journal = Journal.find(params[:journal_id])
    @publications = @journal.publications.where(publication_year: @year).paginate(page: params[:page], per_page: 9).order(:title)
  end

  def affinities
    @journal = Journal.find(params[:journal_id])
    @affinities = Affinity.for(@journal).compact.reject{ |a| a.affinity.nan?}.sort_by(&:affinity)
    # [20*(params[:page])..20*(params[:page])]
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
    params.require(:journal).permit(:name)
  end
end