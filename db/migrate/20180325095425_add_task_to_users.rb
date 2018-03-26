class AddTaskToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :task, index: true, foreign_key: true
  end
end
