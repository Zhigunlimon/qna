class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, :body, presence: true
  validates_presence_of :user_id
end
