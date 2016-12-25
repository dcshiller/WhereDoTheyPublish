class StatusesController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def show
    # format.html   { render :formats => [:html] }
    render text: StatusTracker.instance.get_status_for(params['request_number']).to_json
  end
end
