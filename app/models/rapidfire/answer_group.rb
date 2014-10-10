module Rapidfire
  class AnswerGroup < ActiveRecord::Base
    belongs_to :question_group
    belongs_to :user, polymorphic: true
    has_many   :answers, inverse_of: :answer_group, autosave: true
    after_create :notify

    if Rails::VERSION::MAJOR == 3
      attr_accessible :question_group, :user, :is_read, :day_care_id_read, :payment_status
    end
    
    def notify
      puts "inside notify"
      self.is_read = false
      self.day_care_id_read = self.question_group.day_care_id
      self.save
    end
  end
end
