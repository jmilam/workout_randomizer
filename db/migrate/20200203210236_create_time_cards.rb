class CreateTimeCards < ActiveRecord::Migration[5.2]
  def change
    create_table :time_cards do |t|
      t.integer          :user_id, null: false
      t.integer          :task_id, null: false
      t.datetime        :start_time, null: false
      t.datetime        :end_time
      t.timestamps
    end
  end
end
