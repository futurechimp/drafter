# Load up a database schema and force schema creation
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :articles, :force => true do |t|
    t.string :text
    t.string :photo
    t.timestamps
  end

  create_table :drafts, :force => true do |t|
  	t.text :data
  	t.references :draftable, :polymorphic => true
  end

  change_table :drafts do |t|
    t.index [:draftable_id, :draftable_type]
    t.index :data
  end
end