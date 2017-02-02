class ProjectsController < ApplicationController
  def index
    @focused = "Projects"
    @focused_projects = "All"
  end

  def where_do_they_publish_show
    @query = Query.new("", "", "", "")
    @focused = "Projects"
    @focused_projects = "Where?"
  end

  def where_do_they_publish_query
    @focused = "Projects"
    @focused_projects = "Where?"
    name = params["authors"]
    first_name = name.split(" ")[0]&.titlecase
    last_name = name.split(" ")[-1]&.titlecase
    author = Author.find_by(first_name: first_name, last_name: last_name)
    author_ids = params["author_ids"].split(",").compact.map(&:to_i) + [author&.id].compact
    @authors = (Author.where(id: author_ids)).compact
    @publications = @authors.map(&:publications).flatten
    @journal_count = {}
    @publications.map(&:journal).each do |journal|
      @journal_count[journal] = @publications.count {|pub| pub.journal == journal}
    end
    @journal_count = @journal_count.sort {|a,b| b[1] <=> a[1]}
    render :where_do_they_publish_show
  end

  def journal_affinity_show
    @focused = "Projects"
    @focused_projects = "Affinity"
    @journals = Journal.distinct.joins(:publications).where("publications.id IS NOT NULL").order(:name)
  end

  def journal_affinity_query
    @focused = "Projects"
    @focused_projects = "Affinity"
    @journals = Journal.distinct.joins(:publications).where("publications.id IS NOT NULL").order(:name)
    @journal_1, @journal_2 = Journal.where(id: [params[:journal_1], params[:journal_2]])
    @affinity = @journal_1.co_publication_percentage @journal_2 unless [@journal_1.publications.count, @journal_2.publications.count].any?(&:zero?)
    @authors = Author.distinct.published_in(@journal_1) & Author.published_in(@journal_2)
    render :journal_affinity_show
  end
end
