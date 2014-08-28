# This migration comes from rapidfire (originally 20140808040705)
class AddDetailsToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :description, :text
    add_column :rapidfire_question_groups, :start_time, :datetime
    add_column :rapidfire_question_groups, :end_time, :datetime
    add_column :rapidfire_question_groups, :day_care_id, :integer
    add_column :rapidfire_question_groups, :owner_id, :integer
    add_column :rapidfire_question_groups, :reg_close, :datetime
  end
end
