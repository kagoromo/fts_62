class Subject < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :exams, dependent: :destroy

  validates :content, presence: true
  validates :number_of_questions, presence: true
  validates :duration, presence: true
  validates :chatwork_room_id, presence: true
end
