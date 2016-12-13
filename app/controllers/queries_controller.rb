class QueriesController < ApplicationController
  Query = Struct.new("Query", :authors, :category)

  def new
    
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
    Query.new(params[:authors] - [""], params[:filter])
  end
end
