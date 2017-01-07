class QueriesController < ApplicationController
  def new
    @request_number = "#{rand(1_000_000)}"
    StatusTracker.instance.track_status_for(@request_number)
  end

  def create
    dispatcher = CrossRefDispatcher.new(query)
    dispatcher.dispatch
    publications = dispatcher.response
    filterer = Filterer.new(query: query, publications: publications)
    filterer.filter
    publications = filterer.filtered_list
    counter = Counter.new(publications)
    counter.count
    @ranked_journals = counter.ranked_journals
    respond_to { |format| format.js }
  end

  private

  def query
    Query.new(params[:authors] - [""], params[:filter], params['request_number'])
  end
end
