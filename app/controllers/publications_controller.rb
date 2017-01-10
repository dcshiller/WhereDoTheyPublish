class PublicationsController < ApplicationController
  def index
    @publications = Publication.includes(:authors).includes(:journal).order(:title).paginate(page: params[:page])
  end
end
