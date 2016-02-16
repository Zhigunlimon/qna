FactoryGirl.define do
  sequence :title do |n|
    "title#{n}test"
  end

  factory :question do
    user
    title
    body "Body for Answer"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
