class CreateGarbageWords < ActiveRecord::Migration[7.0]
  def change
    create_table :garbage_words do |t|

      t.timestamps
    end
  end
end
