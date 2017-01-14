class Query
  attr_reader :request_number, :journal, :year, :authors, :category
  attr_accessor :message

  def initialize(authors, category, journal, year, request_number = nil)
    @authors = authors
    @journal = journal
    @year = year
    @category = category
    @request_number = request_number
    StatusTracker.instance.track_status_for(request_number)
    StatusTracker.instance.set_status_for(request_number, "Query received.")
  end

  def update_status(message)
    StatusTracker.instance.set_status_for(request_number, message)
  end
end
