class Answer < ActiveRecord::Base
  belongs_to :question

  validates :question_id, :body, presence: true
end
