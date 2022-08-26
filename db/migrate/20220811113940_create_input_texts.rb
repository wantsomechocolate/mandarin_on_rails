class CreateInputTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :input_texts do |t|

      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :body
      t.boolean :public
      t.integer :hsk_2012
      t.integer :char_cnt
      t.integer :shingle_count

      t.timestamps
    end
  end
end
