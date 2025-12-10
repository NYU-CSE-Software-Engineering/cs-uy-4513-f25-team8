class AddSecurityQuestionsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :security_question_1, :string
    add_column :users, :security_question_2, :string
    add_column :users, :security_answer_1, :string
    add_column :users, :security_answer_2, :string
  end
end
