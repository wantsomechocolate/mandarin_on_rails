class CreateShingles < ActiveRecord::Migration[7.0]
  def change
    create_table :shingles do |t|

      t.references :passage, null: false, foreign_key: true

      t.string :val
      t.integer :freq
      t.integer :hsk_2012
      t.integer :type #an enum

      t.timestamps
    end
  end
end
