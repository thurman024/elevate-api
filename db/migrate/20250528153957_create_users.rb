class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :session_token, index: { unique: true }
      t.integer :games_played, default: 0
      t.timestamps
    end
  end
end
