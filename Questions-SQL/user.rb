require_relative 'tables_requirements'

class User

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |user| User.new(user)}
  end

  def self.find_by_id(id)
    options = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL

    User.new(options[0])
  end

  def self.find_by_name(fname, lname = nil)
    if lname.nil?
      options = QuestionsDatabase.instance.execute(<<-SQL, fname)
        SELECT
          *
        FROM
          users
        WHERE
          fname = ? AND lname IS NULL
        SQL
    else
      options = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
          *
        FROM
          users
        WHERE
          fname = ? AND lname = ?
        SQL
    end

    User.new(options[0])
  end

  attr_accessor :fname, :lname, :id

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise 'already in database!' unless self.id.nil?

    params = [self.fname, self.lname]

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    average = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
         (SUM(like_count.count)/ CAST(COUNT(like_count.count) AS FLOAT)) AS average
      FROM
        questions JOIN (
          SELECT
            question_likes.question_id, COUNT(users.id) AS count
          FROM
            question_likes JOIN users
            ON question_likes.user_id = users.id
          GROUP BY
            question_likes.question_id) as like_count
        ON questions.id = like_count.question_id
        JOIN users
        ON users.id = questions.author
      WHERE
        users.id = ?
      GROUP BY
        users.id;

      SQL
      if average.empty?
        0
      else
        average[0]['average']
      end
  end

end
