FactoryGirl.define do
  factory :publication do
    journal { create :journal }
  end
end
