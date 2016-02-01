FactoryGirl.define do
  factory :answer do
    body "MyText"
    question_id 1
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

end
