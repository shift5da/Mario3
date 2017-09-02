class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :account
      t.string :password
      t.datetime :first_login_at
      t.datetime :last_login_at

      t.timestamps
    end
  end
end
