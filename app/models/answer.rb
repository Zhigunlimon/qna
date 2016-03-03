class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  def self.set_best_answer(answer, question)
    if question.best_answer
      question.best_answer.update_attributes(set_best: false)
    end
    answer.update_attributes(set_best: true)
  end
end
