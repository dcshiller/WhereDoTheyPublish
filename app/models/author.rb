class Author < ActiveRecord::Base
  has_many :authorships
  has_many :publications, through: :authorships

  scope :middle_initial_consistent, ->(mi){ where("middle_initial ~* ?", "^" + mi.to_s + ".*") }

  def name?(name_to_match)
    (first_name .sp last_name) == (name_to_match.split(" ")[0] .sp name_to_match.split(" ")[1]) ||
      (first_name .sp middle_initial .sp last_name == name_to_match)
  end

  def name
    first_name .sp middle_initial .sp last_name
  end
end
