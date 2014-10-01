class AddDayCareIdToRapidfireAnswerGroup < ActiveRecord::Migration
  def change
    add_column :rapidfire_answer_groups, :day_care_id_read, :integer
  end
end
