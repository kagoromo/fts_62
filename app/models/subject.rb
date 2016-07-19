class Subject < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :exams, dependent: :destroy

  validates :content, presence: true
  validates :number_of_questions, presence: true
  validates :duration, presence: true
  validates :chatwork_room_id, presence: true

  def get_chatwork_room_name admin
    ChatWork.api_key = admin.chatwork_api_key
    room = ChatWork::Room.get.find {|room| room["room_id"] == chatwork_room_id.to_i}
    room.present? ? room_name = room["name"] : nil
  end
end
