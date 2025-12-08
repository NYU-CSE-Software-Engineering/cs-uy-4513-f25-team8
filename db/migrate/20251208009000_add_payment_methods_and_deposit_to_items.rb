class AddPaymentMethodsAndDepositToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :payment_methods, :string, default: "credit_card"
    add_column :items, :deposit_amount, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
