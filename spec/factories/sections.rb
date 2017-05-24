FactoryGirl.define do
  factory :section do
    association :course, factory: :course
  end
end
