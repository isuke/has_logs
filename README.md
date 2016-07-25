# HasLogs

Logging your ActiveRecord model, and supply useful methods.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_logs'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install has_logs
```

## Basic Example

### First Migration

```ruby
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
  end
end
```

## Model Class

```ruby
class Article < ActiveRecord::Base
  has_logs
end

class ArticleLog < ActiveRecord::Base
  act_as_log
end
```

## Usage Examples

```ruby
article = Article.create(title: 'test1', content: 'demo1', public: false)
article.attributes =   { title: 'test2', content: 'demo2', public: false } ; article.save!
article.attributes =   { title: 'test3', content: 'demo3', public: true  } ; article.save!

article.title
=> 'test3'

article.logs
=> [#<ArticleLog id: 1, article_id: 1, title: "test1", content: "demo1", created_at: "2015-01-04 03:36:51">,
 #<ArticleLog id: 2, article_id: 1, title: "test2", content: "demo2", created_at: "2015-01-04 03:36:51">,
 #<ArticleLog id: 3, article_id: 1, title: "test3", content: "demo3", created_at: "2015-01-04 03:36:51">]

article.oldest_log
=> #<ArticleLog id: 1, article_id: 1, title: "test1", content: "demo1", created_at: "2015-01-04 03:36:51">

article.latest_log
=> #<ArticleLog id: 3, article_id: 1, title: "test3", content: "demo3", created_at: "2015-01-04 03:36:51">

article.oldest_log.next
=> #<ArticleLog id: 2, article_id: 1, title: "test2", content: "demo2", created_at: "2015-01-04 03:36:51">

article.latest_log.prev
=> #<ArticleLog id: 2, article_id: 1, title: "test2", content: "demo2", created_at: "2015-01-04 03:36:51">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isuke/has_logs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

