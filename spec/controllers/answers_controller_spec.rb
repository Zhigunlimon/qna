require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question){ create(:question, user: user) }
  let(:answer){ create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
        .to change(question.answers, :count).by(1)
      end

      it 'render create view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end

      it 'current_user have new answer' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user).to eq @user
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        .to_not change(Answer, :count)
      end

      it 'render question show' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      let(:foreign_answer) { create(:answer, question: question, user: user) }

      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js 
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'answer new body' }, format: :js 
        answer.reload
        expect(answer.body).to eq 'answer new body'
      end

      it 'try changes answer attributes for foreign answer' do
        patch :update, id: foreign_answer, question_id: question, answer:  { body: 'answer new body' }, format: :js 
        answer.reload
        expect(answer.body).to_not eq 'answer new body'
      end
    end

    context 'Non authenticated user' do
      let(:answer) { create :answer, question: question, user: user }

      it 'does not change answer' do
        patch :update, id: answer, question_id: question, answer:  { body: 'answer new body' }, format: :js 
        answer.reload
        expect(answer.body).to_not eq 'answer new body'
      end
    end
  end

  describe 'PATCH #set_best' do

    context 'signed_in_user' do
      sign_in_user
      let!(:question) { create(:question, user: @user) }
      let!(:answer) { create(:answer, question: question) }
      let(:other_answer) { create(:answer) }

      it 'assigns the requested answer to @answer' do
        patch :set_best, question_id: question, id: answer, format: :js
        expect(assigns(:answer)).to eq answer
        expect(assigns(:question)).to eq question
      end

      it 'changes answer set_best attribute' do
        patch :set_best, id: answer, question_id: answer.question, format: :js
        answer.reload
        expect(answer.best?).to eq true
      end

      it 'render set_best template' do
        patch :set_best, id: answer, question_id: answer.question, format: :js
        answer.reload
        expect(response).to render_template :set_best
      end

      it 'should not select best answer for others question' do
        patch :set_best, id: other_answer, question_id: other_answer.question, format: :js
        other_answer.reload
        expect(other_answer.best?).to eq false
      end
    end
  end

  let(:answer) { create(:answer, question: question, user: @user) }
  let(:foreign_answer) { create(:answer, question: question, user: user) }

  describe 'POST #destroy' do
    sign_in_user
    it "deletes own answer" do
      answer
      expect { delete :destroy, question_id: answer.question_id, id: answer.id, format: :js }.to change(Answer, :count).by(-1)
    end

    it "deletes foregin answer" do
      foreign_answer
      expect { delete :destroy, question_id: answer.question_id, id: answer.id, format: :js }.to_not change(Answer, :count)
    end
  end
end
