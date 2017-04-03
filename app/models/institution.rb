class Institution < ActiveRecord::Base
  has_many :affiliations
  has_many :authors, through: :affiliations
end