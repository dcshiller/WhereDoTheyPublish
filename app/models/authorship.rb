class Authorship < ActiveRecord::Base
  belongs_to :author, dependent: :destroy
  belongs_to :publication
  has_one :journal, through: :publication

  validates :author, :publication, presence: true
end
