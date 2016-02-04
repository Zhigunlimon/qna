require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }

  context 'check if user author' do
    let(:user) { create_list(:user, 2) }
    let(:answer){ create(:answer, user: user.first) }

    it 'should be an author'do
      expect(user.first).to be_author(answer)
    end

    it 'should not be an author'do
      expect(user.second).not_to be_author(answer)
    end
  end
end
