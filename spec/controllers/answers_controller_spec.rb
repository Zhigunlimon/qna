require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question){ create(:question, user: user) }
  let(:answer){ create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }
        .to change(question.answers, :count).by(1)
      end

      it 'render create view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }
        .to_not change(Answer, :count)
      end

      it 'render create view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer) 
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      let(:foreign_answer) { create(:answer, question: question, user: user) }

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer) 
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer:  { body: 'answer new body' } 
        answer.reload
        expect(answer.body).to eq 'answer new body'
      end

      it 'try changes answer attributes for foreign answer' do
        patch :update, id: foreign_answer, question_id: question, answer:  { body: 'answer new body' } 
        answer.reload
        expect(answer.body).to_not eq 'answer new body'
      end

      it 'renders update view' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer) 
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non authenticated user' do
      let(:answer) { create :answer, question: question, user: user }

      it 'does not change answer' do
        patch :update, id: answer, question_id: question, answer:  { body: 'answer new body' } 
        answer.reload
        expect(answer.body).to_not eq 'answer new body'
      end
    end
  end

  let(:answer) { create(:answer, question: question, user: @user) }
  let(:foreign_answer) { create(:answer, question: question, user: user) }

  describe 'POST #destroy' do
    sign_in_user
    it "deletes own answer" do
      answer
      expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to change(Answer, :count).by(-1)
    end

    it "deletes foregin answer" do
      foreign_answer
      expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to_not change(Answer, :count)
    end

    it 'render destroy view' do
      delete :destroy, question_id: answer.question_id, id: answer.id
      expect(response).to redirect_to question_path(answer.question_id)
    end
  end

end
