class CreateMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :measurements do |t|
      t.integer :user_id
      t.integer :upper_arm, default: 0
      t.integer :chest, default: 0
      t.integer :waist, default: 0
      t.integer :hip, default: 0
      t.integer :thigh, default: 0
      t.integer :calf, default: 0
      t.integer :wrist, default: 0
      t.integer :forearm, default: 0
      t.integer :left_tricep, default: 0
      t.integer :right_tricep, default: 0
      t.integer :subscapular, default: 0
      t.integer :abdominal, default: 0
      t.integer :mid_thigh, default: 0
      t.integer :inside_calf, default: 0
      t.integer :pec, default: 0
      t.integer :left_bicep, default: 0
      t.integer :right_bicep, default: 0
      t.integer :suprailiac, default: 0
      t.timestamps
    end
  end
end
