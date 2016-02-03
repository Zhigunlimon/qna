class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  before_action :load_question, except: [:create]
  before_action :check_authority, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answers = @question.answers.all

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      render :new
    end
  end

  def edit
    @answers = @question.answers.all
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question, notice: "Your answer was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question, notice: 'Your answer was successfully deleted.'
  end

  private
  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = @answer.question
  end

  def check_authority
    redirect_to @question, notice: 'You do not author of answer.' unless current_user.author?(@answer)
  end
end
