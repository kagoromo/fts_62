Admin.create!(
  name: "Admin",
  email: "admin@railstutorial.org",
  password: "12345678",
  password_confirmation: "12345678",
  chatwork_name: "11111111111111111111")

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "12345678"
  chatwork_name = "11111111111111111111"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    chatwork_name: chatwork_name)
end

5.times do
  name = Faker::Name.title
  content = Faker::Lorem.sentence
  subject = Subject.create! content: content, number_of_questions: 20,
    duration: 30, chatwork_room_id: "43643696"
end

subject = Subject.all
subject.each do |subject|
  50.times do
    question = subject.questions.build(
      content: Faker::Lorem.sentence,
      question_type: 0,
      status: 1)
    question.answers = [
      Answer.new(content: Faker::Lorem.characters(5), is_correct: true),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false)
    ].shuffle
    question.save!
  end
end

subject.each do |subject|
  10.times do
    question = subject.questions.build(
      content: Faker::Lorem.sentence,
      question_type: 1,
      status: 1)
    question.answers = [
      Answer.new(content: Faker::Lorem.characters(5), is_correct: true),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: true),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false)
    ].shuffle
    question.save!
  end
end

subject.each do |subject|
  10.times do
    question = subject.questions.build(
      content: Faker::Lorem.sentence,
      question_type: 2,
      status: 1)
    question.answers.new content: Faker::Lorem.characters(5),
      is_correct: true
    question.save!
  end
end

users = User.all.order(:created_at)
users.each do |user|
  2.times do
    exams = user.exams.create!(
      status: rand(2),
      spent_time: 22,
      subject_id: rand(Subject.count) +1)
  end
end

exams = Exam.all.where(status: 1)
exams = exams.take(exams.count)
exams.each do |exam|
  exam.results.each do |result|
    answer = result.question.answers.first
    result.update answer: answer, is_correct: answer.is_correct
    result.create_text_answer! content: answer.content if result.question.text?
  end
  exam.update status: 2
end

subjects = Subject.all
subjects.each do |subject|
  5.times do
    question = subject.questions.build(
      content: Faker::Lorem.sentence,
      question_type: 0,
      status: 0)
    question.answers = [
      Answer.new(content: Faker::Lorem.characters(5), is_correct: true),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false),
      Answer.new(content: Faker::Lorem.characters(5), is_correct: false)
    ].shuffle
    question.save!
    question.create_suggested_question! user_id: rand(User.count) + 1
  end
end
