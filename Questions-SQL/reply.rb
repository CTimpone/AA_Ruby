require_relative 'tables_requirements'

class Reply

  def self.find_by_id(id)
    options = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    Reply.new(options[0])
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
      SQL

    replies.map { |reply| Reply.new(reply)}
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
      SQL

      replies.map { |reply| Reply.new(reply)}
  end

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map { |reply| Reply.new(reply)}
  end

  attr_accessor :id, :body, :parent_reply, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @parent_reply = options['parent_reply']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
    raise 'already in database!' unless self.id.nil?

    params = [self.body, self.parent_reply, self.question_id, self.user_id]

    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        replies (body, parent_reply, question_id, user_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    authored_name = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
      SQL
      authored_name[0]['fname'] + " " + authored_name[0]['lname']
  end

  def question
    question = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL

    Question.new(question[0])
  end

  def parent_reply
    parent = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    Reply.new(parent[0])
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply = ?
      SQL

    children.map { |child| Reply.new(child)}
  end
end
