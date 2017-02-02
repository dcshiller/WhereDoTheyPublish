class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:last_name).paginate(page: params[:page], per_page: 10)
    @focused = "Data"
    @focused_datatype = "Authors"
  end

  def show
    @focused = "Data"
    @focused_datatype = "Authors"
    @author = Author.find(params[:id])
    @publications = @author.publications.paginate(page: params[:page], per_page: 10).order(:publication_year)
  end

  def edit
    @focused = "Data"
    @focused_datatype = "Authors"
    @author = Author.find(params[:id])
  end

  def update
    @focused = "Data"
    @focused_datatype = "Authors"
    @author = Author.find(params[:id])
    other_author = (Author.where(author_params).to_a - @author).first
    unless other_author.blank?
      other_author.merge_into(@author)
    else
      @author.update_attributes(author_params)
    end
    @publications = @author.publications.paginate(page: params[:page], per_page: 10).order(:publication_year)
    render :show
  end

  private
  
  def author_params
    params.require(:author).permit(:first_name, :last_name, :middle_initial)
  end
end
