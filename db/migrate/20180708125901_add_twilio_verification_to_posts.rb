class AddTwilioVerificationToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :draft, :boolean, default: true
    add_column :posts, :verification_code, :string
  end
end
