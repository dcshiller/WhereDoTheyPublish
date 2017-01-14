class DataController < ApplicationController  
  def index
    @focused = "Data"
    @focused_datatype = "All"
  end
end