class Authors::AffiliationsController < ApplicationController
  def edit
    @author = @author.find_by(:author_id)
    @affiliations = @author.affiliations
  end
end