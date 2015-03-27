class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :not_author_of_poll

  after_destroy :log_destroy_action

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question

  def log_destroy_action
    puts "Response destroyed!"
  end
  
  def sibling_responses
    self.question.responses.where([':id IS NULL OR responses.id != :id', id: self.id])
  end

  private
  def respondent_has_not_already_answered_question
    current_user = self.user_id
    unless self.sibling_responses.where(user_id: current_user).empty?
      errors[:base] << 'Already responded to this question.'
    end
  end

  def not_author_of_poll
    current_user = self.user_id

    if self.question.poll.author.id == current_user
      errors[:base] << "Author cannot respond to own poll."
    end
  end

end
