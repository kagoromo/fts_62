class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :chatwork_name
      t.string :remember_digest
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
  end
end
