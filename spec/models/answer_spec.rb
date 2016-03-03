require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should belong_to(:question) }
  it { should validate_presence_of :user_id }

  context 'should check the best answer correct' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, set_best: true) }

    it 'check the answer as best and set_best to false for previous' do
      Answer.set_best_answer(answer, question)
      best_answer.reload

      expect(answer.set_best).to be true
      expect(best_answer.set_best).to be false
    end
  end
end
