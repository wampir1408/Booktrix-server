class CreateBorrowBookActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :borrow_book_activities do |t|

      t.timestamps
    end
  end
end
