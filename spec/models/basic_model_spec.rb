require 'spec_helper'

class ArticleLog < ActiveRecord::Base; end
class Article < ActiveRecord::Base
  has_logs dependent: :destroy
end
class ArticleLog < ActiveRecord::Base
  act_as_log
end

describe 'Basic Model' do
  after(:all) { CreateAllTables.down }
  after do
    Article.destroy_all
    ArticleLog.destroy_all
  end

  let!(:article) do
    article = Article.create(title: 'test1', content: 'demo1', public: false)
    article.attributes =   { title: 'test2', content: 'demo2', public: false } ; article.save!
    article.attributes =   { title: 'test3', content: 'demo3', public: true  } ; article.save!
    article
  end
  let!(:article_log) { article.logs.where(title: 'test2').first }

  describe Article do
    subject { article }

    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :title? }
    it { is_expected.to respond_to :content }
    it { is_expected.to respond_to :content? }
    it { is_expected.to respond_to :public }
    it { is_expected.to respond_to :public? }

    it { is_expected.to have_many(:logs).class_name('ArticleLog') }
    it { is_expected.to have_many(:logs).dependent(:destroy) }

    its(:title)   { is_expected.to eq 'test3' }
    its(:content) { is_expected.to eq 'demo3' }
    its(:public)  { is_expected.to eq true }
    its(:latest_log) { is_expected.to eq ArticleLog.find_by(title: 'test3') }
    its(:oldest_log) { is_expected.to eq ArticleLog.find_by(title: 'test1') }
  end

  describe ArticleLog do
    subject { article_log }

    it { is_expected.to respond_to :title }
    it { is_expected.to respond_to :title? }
    it { is_expected.to respond_to :content }
    it { is_expected.to respond_to :content? }
    it { is_expected.to respond_to :public }
    it { is_expected.to respond_to :public? }

    it { is_expected.to belong_to(:originator).class_name('Article') }

    its(:originator) { is_expected.to eq article }
    its(:next) { is_expected.to eq ArticleLog.find_by(title: 'test3') }
    its(:prev) { is_expected.to eq ArticleLog.find_by(title: 'test1') }
  end
end
