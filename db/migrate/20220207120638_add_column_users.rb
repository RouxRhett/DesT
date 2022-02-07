class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name,       :string,  null: false

    add_column :users, :is_deleted, :boolean, null: false

  end
end
