if ActiveRecord.version >= Gem::Version.new('5.1.1')
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  class CreateAllTables < ActiveRecord::Migration[5.1]
    def self.up
      ############################################################################
      # Basic                                                                    #
      ############################################################################
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

      ############################################################################
      # Other Naming                                                             #
      ############################################################################
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

      ############################################################################
      # Duplicate                                                                #
      ############################################################################
      create_table(:tasks) do |t|
        t.string :name, null: false
        t.timestamps
      end
      create_table(:task_logs) do |t|
        t.integer :task_id, null: false
        t.string :name, null: false
        t.datetime :created_at
      end
      add_index :task_logs,  :task_id
      add_index :task_logs, [:task_id, :created_at], unique: true

      ############################################################################
      # Mutual                                                                   #
      ############################################################################
      create_table(:posts) do |t|
        t.string :name, null: false
        t.timestamps
      end
      create_table(:post_logs) do |t|
        t.integer :post_id, null: false
        t.string :name, null: false
        t.datetime :created_at
      end
      add_index :post_logs,  :post_id
      add_index :post_logs, [:post_id, :created_at], unique: true
    end
  end
else
  ActiveRecord::Base.configurations = {'test' => {adapter: 'sqlite3', database: ':memory:'}}
  ActiveRecord::Base.establish_connection :test

  class CreateAllTables < ActiveRecord::Migration
    def self.up
      ############################################################################
      # Basic                                                                    #
      ############################################################################
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

      ############################################################################
      # Other Naming                                                             #
      ############################################################################
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

      ############################################################################
      # Duplicate                                                                #
      ############################################################################
      create_table(:tasks) do |t|
        t.string :name, null: false
        t.timestamps
      end
      create_table(:task_logs) do |t|
        t.integer :task_id, null: false
        t.string :name, null: false
        t.datetime :created_at
      end
      add_index :task_logs,  :task_id
      add_index :task_logs, [:task_id, :created_at], unique: true

      ############################################################################
      # Mutual                                                                   #
      ############################################################################
      create_table(:posts) do |t|
        t.string :name, null: false
        t.timestamps
      end
      create_table(:post_logs) do |t|
        t.integer :post_id, null: false
        t.string :name, null: false
        t.datetime :created_at
      end
      add_index :post_logs,  :post_id
      add_index :post_logs, [:post_id, :created_at], unique: true
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
