FactoryGirl.define do
  factory :tweet do
    user
    sequence(:content) { |n| "tweet_content#{n}" }
  end

end
