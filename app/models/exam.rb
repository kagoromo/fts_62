class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  has_many :results, dependent: :destroy

  enum status: [:start, :testing, :unchecked, :checked]

  validate :check_number_question

  after_create :create_result_for_exam
  after_update :check_results

  accepts_nested_attributes_for :results

  def send_score_to_chatwork admin
    ChatWork.api_key = admin.chatwork_api_key
    room_id = subject.chatwork_room_id
    to_account = ChatWork::Member.get(room_id: room_id).find {|member|
      member["name"] == user.chatwork_name}
    if to_account
      to_account_id = to_account["account_id"]
      body = I18n.t "exam.chatwork_message", id: to_account_id, name: user.chatwork_name,
        score: score, total: subject.number_of_questions, subject: subject.content
    else
      body = I18n.t "exam.chatwork_message_without_to", name: user.chatwork_name,
        score: score, total: subject.number_of_questions, subject: subject.content
    end
    ChatWork::Message.create room_id: room_id, body: body
  end
  # handle_asynchronously :send_score_to_chatwork

  def calculated_score
    results.correct.count
  end

  def calculated_spent_time
    interval = Time.zone.now - started_at
    interval > subject.duration * 60 ? subject.duration * 60 : interval
  end

  def check_results
    results.each do |result|
      result.check_result
    end
  end

  def remaining_time
    unchecked? || checked? ? 0 : subject.duration * 60 - (Time.zone.now -
      started_at).to_i
  end

  def spent_time_format
    Time.at(spent_time).utc.strftime I18n.t("time.formats.clock")
  end

  def time_out?
    unchecked? || checked? || (Time.zone.now >
      (started_at.nil? ? updated_at : started_at) + subject.duration.minutes)
  end

  def update_status_exam
    update_attributes spent_time: calculated_spent_time if testing?
    update_attributes status: :unchecked if time_out? && testing?
  end

  private
  def check_number_question
    errors.add :base, I18n.t("subject.not_enought_question") if
      subject.number_of_questions > subject.questions.count
  end

  def create_result_for_exam
    Result.transaction do
      begin
        subject.questions.approved.random.limit(
          subject.number_of_questions).each do |question|
          question.results.create exam: self
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end
end
