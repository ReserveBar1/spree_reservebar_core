class CreateHennessyEmailTable < ActiveRecord::Migration
  def change
    create_table :hennessy_emails do |t|
      t.string   :email
      t.boolean  :opt_in, :default => false

      t.timestamps
    end
  end
end
