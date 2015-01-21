module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true
    has_many :answer_groups

               include Authority::Abilities
    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
    

    def answer_read
	read_count = self.answer_groups.where(:is_read => false).count
        if read_count > 0
          true
	else
	  false
         end
    end
  end
end
