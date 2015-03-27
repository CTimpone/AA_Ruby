require_relative 'tables_requirements'

class QuestionLike

  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes JOIN users
        ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
      SQL

    users.map { |user| User.new(user)}
  end

  def self.num_likes_for_question_id(question_id)
    count = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        question_likes.question_id, COUNT(users.id) AS count
      FROM
        question_likes JOIN users
        ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
      SQL

    count[0]['count']

  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_likes JOIN questions
        ON question_likes.question_id = questions.id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        ?
      SQL
      questions.map { |question| Question.new(question)}
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes JOIN questions
        ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
      SQL

    questions.map { |question| Question.new(question)}
  end

  def initialize(options = {})
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
