require_relative 'tables_requirements'

class QuestionFollower

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        questions.*
      FROM
        users JOIN question_followers
        ON users.id = question_followers.user_id
        JOIN questions
        ON question_followers.question_id = questions.id
      WHERE
        questions.id = ?
      SQL

    followers.map { |user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions JOIN question_followers
        ON questions.id = question_followers.question_id
        JOIN users
        ON question_followers.user_id = users.id
      WHERE
        users.id = ?
      SQL

    questions.map { |question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions JOIN question_followers
        ON questions.id = question_followers.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_followers.user_id) DESC
      LIMIT
        ?
      SQL

    questions.map { |question| Question.new(question)}
  end


  attr_accessor :user_id, :question_id

  def initialize(options = {})
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
