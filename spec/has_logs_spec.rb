require 'spec_helper'
require 'models'

describe HasLogs do
  it 'has a version number' do
    expect(HasLogs::VERSION).to eq "0.5.0"
  end

  describe 'Article and ArticleLog' do
    let!(:article) do
      article = Article.create(title: 'test1', content: 'demo1', public: false)
      article.attributes =   { title: 'test2', content: 'demo2', public: false } ; article.save!
      article.attributes =   { title: 'test3', content: 'demo3', public: true  } ; article.save!
      article
    end
    let!(:article_log) { article.logs.where(title: 'test2').first }

    after do
      Article.destroy_all
      ArticleLog.destroy_all
    end

    describe Article do
      subject { article }

      it { is_expected.to respond_to :title }
      it { is_expected.to respond_to :title? }
      it { is_expected.to respond_to :content }
      it { is_expected.to respond_to :content? }
      it { is_expected.to respond_to :public }
      it { is_expected.to respond_to :public? }

      it { is_expected.to have_many(:logs).class_name('ArticleLog') }

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

  describe 'User and UserHistory' do
    let!(:user) do
      user  = User.create(name: 'name1')
      user.attributes = { name: 'name2' } ; user.save!
      user.attributes = { name: 'name3' } ; user.save!
      user
    end
    let!(:user_history) { user.logs.where(name: 'name1').first }

    after do
      User.destroy_all
      UserHistory.destroy_all
    end

    describe User do
      subject { user }

      it { is_expected.to have_many(:logs).class_name('UserHistory') }
      it { is_expected.to have_many(:logs).dependent(:destroy) }
    end

    describe UserHistory do
      subject { user_history }

      it { is_expected.to belong_to(:originator).class_name('User') }
      its(:originator) { is_expected.to eq user }
    end
  end

end
