require 'rails_helper'

feature 'Edit questions' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  describe 'Authenticated user' do
    scenario 'trying to edit others question' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end

    scenario 'edit own question', js: true do
      sign_in(user)
      visit question_path(question)

      within '#question' do
        click_on 'Edit question'
        fill_in 'question_title', with: 'Updated title'
        fill_in 'question_body', with: 'Updated body'
        click_on 'save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Updated title'
        expect(page).to have_content 'Updated body'
      end
    end
  end

  scenario 'Non-authenticated user trying to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
