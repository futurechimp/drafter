# Load up a database schema and force schema creation
ActiveRecord::Schema.define do
  self.verbose = false

  # These ones are the tables that the library really relies on.
  create_table :drafts, :force => true do |t|
    t.integer :parent_id
    t.string  :parent_association_name
    t.text :data
    t.references :draftable, :polymorphic => true
  end

  change_table :drafts do |t|
    t.index [:draftable_id, :draftable_type]
    t.index :data
  end

  create_table :draft_uploads, :force => true do |t|
    t.references :draft
    t.string :draftable_mount_column
    t.string :file_data
  end

  # From here down, we use them for testing purposes only.
  create_table :articles, :force => true do |t|
    t.string :text
    t.string :upload
    t.timestamps
  end

  create_table :users, :force => true do |t|
    t.string :email
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.integer :article_id
    t.string  :upload
    t.string :text
  end

  create_table :likes, :force => true do |t|
    t.references :likeable, :polymorphic => true
  end

end