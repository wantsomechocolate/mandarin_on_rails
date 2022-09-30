class CreateUserWords < ActiveRecord::Migration[7.0]
  def change
    create_table :user_words do |t|
      t.references :user, index: true, foreign_key: true
      t.string :word, index:true
      t.boolean :known
      t.text :definition
      t.timestamps
    end
  end
end
