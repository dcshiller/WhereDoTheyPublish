FactoryGirl.define do
  factory :author do
    first_name { Faker::Name.first_name }
    middle_initial { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  
    trait :with_publication do
      after(:create) do |a|
        create :authorship, author: a, publication: create(:publication)
      end
    end
  end
end
