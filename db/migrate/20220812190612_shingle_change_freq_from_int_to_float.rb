class ShingleChangeFreqFromIntToFloat < ActiveRecord::Migration[7.0]
  def up
    change_column :shingles, :freq, :float
  end

  def down
    change_column :shingles, :freq, :int
  end
end
