FactoryGirl.define do
  factory :answer do
    body "Body for question"
    user
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

end
