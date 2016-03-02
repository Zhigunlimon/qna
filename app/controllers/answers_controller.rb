class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, except: [:create, :new, :set_best]
  before_action :check_authority, except: [:create, :new, :set_best]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answers = @question.answers.all
    @answer.save
  end

  def edit
    @answers = @question.answers.all
  end

  def update
    @answer.update(answer_params)
  end

  def set_best
    answer_id = params[:answer_id] || params[:id]
    @answer = @question.answers.find(answer_id)
    if current_user.author?(@question)
      if @question.best_answer
        @question.best_answer.update(set_best: false)
      end
      @answer.update(set_best: true)
    end
  end

  def destroy
    @answer.destroy
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def check_authority
    redirect_to @question, notice: 'You are not thr author of answer.' unless current_user.author?(@answer)
  end
end
