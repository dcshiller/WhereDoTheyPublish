class JournalsController < ApplicationController
  def index
    @journals = Journal.order(:name).paginate(page: params[:page], per_page: 20)
    @focused = "Data"
    @focused_datatype = "Journals"
  end
end