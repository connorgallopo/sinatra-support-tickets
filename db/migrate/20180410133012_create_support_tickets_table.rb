class CreateSupportTicketsTable < ActiveRecord::Migration
  def change
    create_table :support_tickets do |t|
      t.string :subject
      t.string :body
      t.integer :status
      t.integer :user_id
    end
  end
end
