class CreateKnownWords < ActiveRecord::Migration[7.0]
  def change
    create_table :known_words do |t|
      t.references :user, index: true, foreign_key: true
      t.string :word, index:true
      t.timestamps
    end
  end
end
