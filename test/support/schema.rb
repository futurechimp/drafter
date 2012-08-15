# Load up a database schema and force schema creation
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :articles, :force => true do |t|
    t.string :text
    t.timestamps
  end

  create_table :drafts, :force => true do |t|
  	t.text :data 
  end
end