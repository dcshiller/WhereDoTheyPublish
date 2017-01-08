class Authorship < ActiveRecord::Base
  belongs_to :author, dependent: :destroy
  belongs_to :publication
  
  validates :author, :publication, presence: true
end
