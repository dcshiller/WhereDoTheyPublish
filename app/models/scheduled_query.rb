class ScheduledQuery < ApplicationRecord
  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }
end