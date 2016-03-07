require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should belong_to(:question) }
  it { should validate_presence_of :user_id }

  context 'should check the best answer correct' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'check the answer as bes' do
      answer.set_best

      expect(answer.best).to be true
    end

    it 'set_best to false for previous best answer' do
      answer.set_best
      best_answer.reload

      expect(best_answer.best).to be false
    end
  end
end
