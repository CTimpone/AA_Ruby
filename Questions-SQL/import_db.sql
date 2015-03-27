CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(20) NOT NULL,
  lname VARCHAR(20)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,

  author INTEGER NOT NULL,
  FOREIGN KEY (author) REFERENCES users(id)
);

CREATE TABLE question_followers (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,

  parent_reply INTEGER,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (parent_reply) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- In addition to creating tables, we can seed our database with some
-- starting data.
INSERT INTO
  users (fname, lname)
VALUES
  ('Ricky', 'Bobby'),
  ('Elf', NULL),
  ('Ron', 'Burgandy'),
  ('Will', 'Ferrell');

INSERT INTO
  questions (title, body, author)
VALUES
  ('first post', 'If youre not first youre last!', (SELECT id FROM users WHERE fname = 'Ricky' AND lname = 'Bobby')),
  ('Elf post', 'whatever', (SELECT id FROM users WHERE fname = 'Elf' AND lname IS NULL)),
  ('Rons post', 'idk', (SELECT id FROM users WHERE fname = 'Ron' AND lname = 'Burgandy'));


INSERT INTO
  question_followers (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Ron' AND lname = 'Burgandy'),
  (SELECT id FROM questions WHERE title = 'first post')),

  ((SELECT id FROM users WHERE fname = 'Elf' AND lname IS NULL),
  (SELECT id FROM questions WHERE title = 'first post'));

INSERT INTO
  replies(body, parent_reply, question_id, user_id)
VALUES
  ('top level 1', NULL, (SELECT id FROM questions WHERE title = 'first post'), (SELECT id FROM users WHERE fname = 'Elf' AND lname IS NULL)),
  ('top level 2', NULL, (SELECT id FROM questions WHERE title = 'first post'), (SELECT id FROM users WHERE fname = 'Ron' AND lname = 'Burgandy'));

INSERT INTO
  question_likes( user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Will' AND lname = 'Ferrell'), (SELECT id FROM questions WHERE title = 'first post')),
  ((SELECT id FROM users WHERE fname = 'Will' AND lname = 'Ferrell'), (SELECT id FROM questions WHERE title = 'Elf post')),
  ((SELECT id FROM users WHERE fname = 'Will' AND lname = 'Ferrell'), (SELECT id FROM questions WHERE title = 'Rons post'));

INSERT INTO
  replies(body, parent_reply, question_id, user_id)
VALUES
  ('response to 1', (SELECT id FROM replies WHERE body = 'top level 1'), (SELECT id FROM questions WHERE title = 'first post'), (SELECT id FROM users WHERE fname = 'Ricky' AND lname = 'Bobby'));
