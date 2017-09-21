class CreateSpreeStripeSources < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_stripe_sources do |t|
      t.string :source
      t.string :token
      t.string :return_url
      t.text :data
      t.integer :user_id, index: true
      t.references :payment_method, index: true

      t.timestamps
    end
  end
end
