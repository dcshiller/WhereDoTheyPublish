FactoryGirl.define do
  factory :publication do
    journal { create :journal }
    publication_year 1970
  end
end
