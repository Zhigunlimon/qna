require 'rails_helper'

feature 'Views questions list' do
  let(:user) { create(:user) }
  let!(:question) { create_list(:question, 2) }
  let!(:answer) { create(:answer, question: question[1], user: user) }

  before(:each) do |skip|
    unless skip.metadata[:skip_before]
      visit root_path
    end
  end

  scenario 'user view questions list' do
    expect(page).to have_content question[0].title && question[1].title
  end

  scenario 'user views question with answers' do
    click_on question[1].title
    expect(page).to have_content question[1].title
    expect(page).to have_content question[1].answers.first.body
  end
end
