class CreateSupportTicketsTable < ActiveRecord::Migration
  def change
    create_table :support_tickets do |t|
      t.string :subject
      t.string :content
      t.integer :user_id
    end
  end
end
