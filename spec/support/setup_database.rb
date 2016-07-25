ActiveRecord::Base.configurations = {'test' => {adapter: 'sqlite3', database: ':memory:'}}
ActiveRecord::Base.establish_connection :test

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:articles) do |t|
      t.timestamps
    end

    create_table(:article_logs) do |t|
      t.integer :article_id, null: false
      t.string :title, null: false
      t.text :content
      t.boolean :public, null: false, default: true
      t.datetime :created_at
    end
    add_index :article_logs,  :article_id
    add_index :article_logs, [:article_id, :created_at], unique: true

    create_table(:users) do |t|
      t.timestamps
    end

    create_table(:user_histories) do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.datetime :created_at
    end

    add_index :user_histories,  :user_id
    add_index :user_histories, [:user_id, :created_at], unique: true
  end

end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
