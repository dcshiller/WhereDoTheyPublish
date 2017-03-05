class AuthorsController < ApplicationController
  include ApplicationHelper
  before_action :set_show_values
  before_action :find_author, only: [:show, :edit, :update]
  
  def index
    @authors = Author.order(:last_name).paginate(page: params[:page], per_page: 20)
  end

  def show
    @publications = @author.publications.articles.paginate(page: params[:page], per_page: 10).order(:publication_year)
  end

  def edit
  end

  def update
    other_author = (Author.where(author_params).to_a - [@author]).first
    unless other_author.blank?
      @author.merge_into(other_author)
      @author = other_author
    else
      @author.update_attributes(author_params)
    end
    @publications = @author.publications.paginate(page: params[:page], per_page: 10).order(:publication_year)
    render :show
  end

  def find
    @search_string = params[:name]
    @authors = @search_string ? Author.with_name_like(@search_string).limit(10) : []
    @none_found = true if @search_string && !@authors.exists?
  end

  private

  def find_author
    @author = Author.find(params[:id])
  end

  def set_show_values
    @focused = "Data"
    @focused_datatype = "Authors"
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :middle_initial)
  end
end
