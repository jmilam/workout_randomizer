class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
    	t.string	:subject
    	t.text		:detail
      t.timestamps
    end
  end
end
