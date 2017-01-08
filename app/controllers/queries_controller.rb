class QueriesController < ApplicationController
  def new
    @request_number = "#{rand(1_000_000)}"
    StatusTracker.instance.track_status_for(@request_number)
  end

  def create
    dispatcher = CrossRefDispatcher.new(query)
    dispatcher.dispatch
    PubSaver.save(dispatcher.response)
    # publications = dispatcher.response
    # filterer = Filterer.new(query: query, publications: publications)
    # filterer.filter
    # publications = filterer.filtered_list
    authors = query.authors.map do |author|
      first_name = author.split(" ")[0]
      last_name = author.split(" ")[-1]
      author = Author.find_by(first_name: first_name, last_name: last_name)
    end
    publications = Publication.joins(:authorships).where("authorships.author": authors)
    counter = Counter.new(publications)
    counter.count
    @ranked_journals = counter.ranked_journals
    respond_to { |format| format.js }
  end

  private

  def query
    @query ||= Query.new(params[:authors] - [""], params[:filter], params['request_number'])
  end
end
