class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, :user_id, presence: true
end
