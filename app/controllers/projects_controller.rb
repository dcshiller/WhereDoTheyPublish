class ProjectsController < ApplicationController
  before_action :set_show_values
  
  def index
  end

  def where_do_they_publish_show
    @query = Query.new("", "", "", "")
    @focused_projects = "Where?"
  end

  def where_do_they_publish_query
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
    @focused_projects = "Affinity"
    @journals = Journal.distinct.joins(:publications).where("publications.id IS NOT NULL").order(:name)
  end

  def journal_affinity_query
    @focused_projects = "Affinity"
    @journals = Journal.distinct.joins(:publications).where("publications.id IS NOT NULL").order(:name)
    @journal_1, @journal_2 = Journal.where(id: [params[:journal_1], params[:journal_2]])
    @affinity = @journal_1.co_publication_percentage @journal_2 unless [@journal_1.publications.count, @journal_2.publications.count].any?(&:zero?)
    @authors = Author.distinct.published_in(@journal_1) & Author.published_in(@journal_2)
    render :journal_affinity_show
  end

  def journal_counts
    @focused_projects = "Journal Counts"
    journal_starts = Journal.group(:publication_start).count
    journal_ends = Journal.group(:publication_end).count
    @journals_current = {}
    (1860..2017).each do |year|
      @journals_current[year] = (@journals_current[year - 1] || 0) + (journal_starts[year] || 0) - (journal_ends[year] || 0)
    end
  end

  def publication_counts
    @focused_projects = "Publication Counts"
    @pubs_count = Publication.articles.group(:publication_year).count
  end

  def gender_balance_chart
    @journals = Journal.all
    @focused_projects = "Gender Balance Chart"
    @gender_by_year = {}
    @gender_by_year = Rails.cache.fetch('gender_chart') { Hash[
        *(1876..2016).map { |year| [year, Publication.articles.year(year).joins(:authors).average(:gender).to_f] }.flatten
    ] }
  end

  def title_ngram_chart
    if params[:title]
      @journals = Journal.all
      @focused_projects = "Title Ngram Chart"
      @gender_by_year = {}
      @title_by_year = Rails.cache.fetch('ngram_chart') { Hash[
          *(1876..2016).map { |year| [year, Publication.where("title LIKE '%#{params[:title]}%'").articles.year(year).count("publications.id").to_f / Publication.year(year).count ] }.flatten
      ] }
    end
  end

  private

  def set_show_values
    @focused = "Projects"
  end
end
