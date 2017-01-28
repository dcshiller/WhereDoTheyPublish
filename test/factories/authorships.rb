FactoryGirl.define do
  factory :authorship do
    association :publication
    association :author
  end
end
