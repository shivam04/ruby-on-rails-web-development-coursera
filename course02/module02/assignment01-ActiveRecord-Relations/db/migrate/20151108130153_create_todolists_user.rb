class CreateTodolistsUser < ActiveRecord::Migration
  def change
    create_table :todolists_users do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
