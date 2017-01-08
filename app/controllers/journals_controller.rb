class JournalsController < ApplicationController
  def index
    @journals = Journal.order(:name).all
  end
end