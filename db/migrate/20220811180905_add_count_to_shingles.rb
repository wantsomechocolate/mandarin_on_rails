class AddCountToShingles < ActiveRecord::Migration[7.0]
  def change
    add_column :shingles, :count, :integer 
    remove_column :shingles, :type 
    add_column :shingles, :shingle_type, :integer
  end
end
