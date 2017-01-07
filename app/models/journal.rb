class Journal < ActiveRecord::Base
  has_many :publications

  scope :philosophy, -> { where(philosophy: true)} 

  
  def self.condensed_name(name)
    cn = name.remove("The ", "A ", "'")
    cn = cn.split(":").first
    cn = cn.split("- ").first
    cn = cn.gsub("  ", " ")
    cn = cn.strip
  end
end