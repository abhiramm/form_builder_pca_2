class AddIsReadToRapidfireAnswerGroup < ActiveRecord::Migration
  def change
    add_column :rapidfire_answer_groups, :is_read, :boolean
  end
end
