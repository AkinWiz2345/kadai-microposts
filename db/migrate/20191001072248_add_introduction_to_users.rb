class AddIntroductionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :integer, default: 0
    add_column :users, :birthday, :date
    add_column :users, :hometown, :string
    add_column :users, :remarks, :text
  end
end
