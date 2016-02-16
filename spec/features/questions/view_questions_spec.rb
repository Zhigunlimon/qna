require 'rails_helper'

feature 'Views questions list' do
  let(:user) { create(:user) }
  let!(:question) { create_list(:question, 2) }
  let!(:answer) { create_list(:answer, 3, question: question[1], user: user) }

  before { visit root_path }

  scenario 'user view questions list' do
    expect(page).to have_content question[0].title && question[1].title
  end

  scenario 'user views question with answers' do
    click_on question[1].title
    expect(page).to have_content question[1].title
    expect(page).to have_content question[1].body
    answer.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
