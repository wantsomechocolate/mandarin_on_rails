class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, index: true, unique: true
    add_column :users, :name, :string, index: true
    add_column :users, :slug, :string, index: true
    add_column :users, :config, :json
    add_column :users, :avatar, :attachment
  end
end
