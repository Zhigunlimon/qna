class Question < ActiveRecord::Base
  has_many :answers, -> { order('set_best DESC') }, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def best_answer
    answers.where(set_best: true).first
  end
end
