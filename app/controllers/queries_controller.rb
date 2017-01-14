class QueriesController < ApplicationController
  def show
    @query = Query.new("", "", "", "")
    @focused = "Projects"
    @focused_projects = "Where?"
  end

  def create
    @focused = "Projects"
    @focused_projects = "Where?"
    name = params["authors"]
    first_name = name.split(" ")[0]&.titlecase
    last_name = name.split(" ")[-1]&.titlecase
    author = Author.find_by(first_name: first_name, last_name: last_name)
    puts params["author_ids"]
    author_ids = params["author_ids"].split(",").compact.map(&:to_i) + [author&.id].compact
    @authors = (Author.where(id: author_ids)).compact
    @publications = @authors.map(&:publications).flatten
    @journal_count = {}
    @publications.map(&:journal).each do |journal|
      @journal_count[journal] = @publications.count {|pub| pub.journal == journal}
    end
    @journal_count = @journal_count.sort {|a,b| b[1] <=> a[1]}
    render :show
  end
end
