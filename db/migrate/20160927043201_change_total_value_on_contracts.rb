class ChangeTotalValueOnContracts < ActiveRecord::Migration[5.0]
  def up
    change_table :contracts do |t|
      t.change :total_value, :decimal
    end
  end
  def down
    change_table :contracts do |t|
      t.change :total_value, :numeric
    end
  end
end