require 'rails_helper'

feature 'deletes answer' do
  let(:user) { create_list(:user, 2) }
  let(:question) { create(:question, user: user[1]) }
  let!(:answer) { create(:answer, question: question, user: user[1]) }

  scenario 'succesfully deletes self created answer' do
    sign_in(user[1])
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'fails to delete foreign answer' do
    sign_in(user[0])
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end
end
