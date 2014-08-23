class AddFormTypeToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :form_type, :string
  end
end
