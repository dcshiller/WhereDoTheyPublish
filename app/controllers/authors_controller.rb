class AuthorsController < ApplicationController
  before_action :set_show_values
  before_action :find_author, only: [:show, :edit, :update]

  def index
    @search_string = params[:name]
    @authors = @search_string ? Author.with_name_like(@search_string).paginate(page: params[:page], per_page: 6) : []
    @none_found = true if @search_string && !@authors.exists?
  
  end

  def show
    @publications = @author.publications.articles.paginate(page: params[:page], per_page: 10).order(:publication_year, :volume, :number, :pages)
    sift_categories(@author)
  end

  def edit
  end

  def update
    other_author = (Author.where(
                                   first_name: author_params[:first_name],
                                   middle_initial: author_params[:middle_initial],
                                   last_name: author_params[:last_name]
                                 ).to_a - [@author]).first
    unless other_author.blank?
      @author.merge_into(other_author)
      @author = other_author
    else
      @author.update_attributes(author_params)
    end
    redirect_to author_path(@author || other_author)
  end

  def find
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
    params.require(:author).permit(:first_name, :last_name, :middle_initial, :birth_year, :death_year)
  end
end
