class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true

  def set_best
    ActiveRecord::Base.transaction do
      if question.best_answer
        question.best_answer.update!(best: false)
      end
      update!(best: true)
    end
  end
end
