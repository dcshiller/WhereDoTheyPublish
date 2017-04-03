class Affiliation < ActiveRecord::Base
  belongs_to :institution
  belongs_to :author
end