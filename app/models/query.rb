class Query
  attr_reader :request_number, :authors, :category
  attr_accessor :message

  def initialize(authors, category, request_number = nil)
    @authors = authors
    @category = category
    @request_number = request_number
    StatusTracker.instance.track_status_for(request_number)
    StatusTracker.instance.set_status_for(request_number, "Query received.")
  end

  def update_status(message)
    StatusTracker.instance.set_status_for(request_number, message)
  end
end
