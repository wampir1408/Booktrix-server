class CreateBorrows < ActiveRecord::Migration[5.0]
  def change
    create_table :borrows do |t|
      t.references :user, foreign_key: true
      t.references :user_book, foreign_key: true

      t.timestamps
    end
  end
end
