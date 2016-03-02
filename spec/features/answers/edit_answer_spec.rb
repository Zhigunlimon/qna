require 'rails_helper'

feature 'Edit answers' do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user trying to edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'trying to edit others answers' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits own answers', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
        fill_in 'answer_body', with: 'Updated body'
        click_on 'save'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'Edit answer'
      end
      expect(find('.answers').text).to match(/Updated body/) 
    end
  end
end
