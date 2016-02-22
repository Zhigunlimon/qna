require 'rails_helper'

feature 'Create answer' do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'Authenticated user create answer to question', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer[body]', with: 'body for the answer'
    click_on 'Post answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'body for the answer'
    end
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Post answer'
  end
end
