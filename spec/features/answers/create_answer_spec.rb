require 'rails_helper'

feature 'Create question' do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'Authenticated user create answer to the question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Create Answer'
    fill_in 'answer[body]', with: 'body for the answer'
    click_on 'Post answer'

    expect(page).to have_content 'Your answer was successfully created.'
    expect(page).to have_content 'body for the answer'
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Create Answer'
  end
end
