class PublicationsController < ApplicationController
  def index
    @publications = Publication.includes(:authors).includes(:journal).order(:title).all
  end
end
