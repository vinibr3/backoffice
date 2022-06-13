class CreateRuleRuleables < ActiveRecord::Migration[6.0]
  def change
    create_table :rule_ruleables do |t|
      t.references :rule
      t.references :ruleable, polymorphic: true
      t.references :inactivator
      t.datetime :inactive_at
    end
  end
end
