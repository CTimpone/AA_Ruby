class User < ActiveRecord::Base
  validates :username, presence: true

  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
  )

  def completed_polls
    subquery = Response
              .select('COUNT(responses.user_id) AS response_count, answer_choices.id AS answer_id')
              .joins('LEFT OUTER JOIN
                      answer_choices ON answer_choices.id = responses.answer_choice_id')
              .where(['responses.user_id = ?', self.id])
              .group('answer_choices.id')

    subquery = subquery.to_sql
    query = Poll
      .select('polls.*, COUNT(DISTINCT(questions.id)) AS question_count')
      .joins('JOIN questions ON questions.poll_id = polls.id')
      .joins('JOIN answer_choices ON answer_choices.question_id = questions.id')
      .joins("LEFT OUTER JOIN (#{subquery}) AS answered_questions ON
              answer_choices.id = answered_questions.answer_id")
      .group('polls.id')
      .having('COUNT(answered_questions.answer_id) = COUNT(DISTINCT(questions.id))')
  end

  def uncompleted_polls
    subquery = Response
              .select('COUNT(responses.user_id) AS response_count, answer_choices.id AS answer_id')
              .joins('LEFT OUTER JOIN
                      answer_choices ON answer_choices.id = responses.answer_choice_id')
              .where(['responses.user_id = ?', self.id])
              .group('answer_choices.id')

    subquery = subquery.to_sql
    query = Poll
      .select('polls.*, COUNT(DISTINCT(questions.id)) AS question_count')
      .joins('JOIN questions ON questions.poll_id = polls.id')
      .joins('JOIN answer_choices ON answer_choices.question_id = questions.id')
      .joins("LEFT OUTER JOIN (#{subquery}) AS answered_questions ON
              answer_choices.id = answered_questions.answer_id")
      .where(['polls.author != ?', self])
      .group('polls.id')
      .having('COUNT(answered_questions.answer_id) < COUNT(DISTINCT(questions.id))')
  end

end
