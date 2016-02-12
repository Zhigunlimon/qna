require 'rails_helper'

feature 'deletes question' do
  let(:user) { create_list(:user, 2) }
  let!(:question) { create(:question, user: user[1]) }

  scenario 'succesfully deletes self created question' do
    sign_in(user[1])
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'fails to delete foreign answer' do
    sign_in(user[0])
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
