FactoryGirl.define do
  factory :course do
    association :school, factory: :school
  end
end