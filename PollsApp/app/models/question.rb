class Question < ActiveRecord::Base
  validates :body, :poll_id, presence: true


  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many :responses, through: :answer_choices, source: :responses,
           dependent: :destroy

  def results
    answer_frequency = self.answer_choices
      .select('COUNT(responses.user_id) AS answer_count, answer_choices.*')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .group('answer_choices.id')

    answer_frequency_hash = Hash.new {|h, k| h[k] = 0}
    answer_frequency.each do |choice|
      answer_frequency_hash[choice.answer] = choice.answer_count
    end

    answer_frequency_hash
  end

end
