class UpdateShingleReference2 < ActiveRecord::Migration[7.0]
  def change

    add_reference :shingles, :input_text, foreign_key: true

  end
end
