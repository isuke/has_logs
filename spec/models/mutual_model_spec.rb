require 'spec_helper'

class PostLog < ActiveRecord::Base; end
class Post < ActiveRecord::Base
  has_logs have_type: :mutual
end
class PostLog < ActiveRecord::Base
  act_as_log
end

describe 'Mutual Model' do
  after(:all) { CreateAllTables.down }
  after do
    Post.destroy_all
    PostLog.destroy_all
  end

  let!(:post) do
    post  = Post.create(name: 'name1')
    post.attributes = { name: 'name2' } ; post.save!
    post.attributes = { name: 'name3' } ; post.save!
    post
  end
  let!(:post_log) { post.logs.find_by(name: 'name2') }

  describe Post do
    subject { post }

    it { is_expected.to eq Post.find_by(name: 'name3') }
    it 'should have 2 logs' do
      expect(post.logs.count).to eq 2
    end
  end

  describe PostLog do
    subject { post_log }
  end
end
