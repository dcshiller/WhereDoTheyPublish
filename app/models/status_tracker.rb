class StatusTracker
  include Singleton
  
  Request = Struct.new("Request", :start_time, :end_time, :message)
  
  def initialize
    @store = {}
  end

  def track_status_for(request_number)
    @store[request_number] ||= Request.new(Time.now, nil, "Waiting for Query.")
  end

  def set_status_for(request_number, message)
    @store[request_number].message = message
  end

  def get_status_for(request_number)
    @store[request_number].message
  end
end
