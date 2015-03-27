require_relative 'tables_requirements'

class Question

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def self.find_by_id(id)
    options = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL

    Question.new(options[0])
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author = ?
      SQL

    questions.map { |question| Question.new(question)}
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |question| Question.new(question)}
  end

  attr_accessor :title, :body, :id, :author_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author']
  end

  def create
    raise 'already in database!' unless self.id.nil?

    params = [self.title, self.body, self.author_id]

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        questions (title, body, author)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    authored_name = QuestionsDatabase.instance.execute(<<-SQL, @author)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
      SQL
      authored_name[0]['fname'] + " " + authored_name[0]['lname']
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
