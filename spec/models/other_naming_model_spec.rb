require 'spec_helper'

class UserHistory < ActiveRecord::Base; end
class User < ActiveRecord::Base
  has_logs_as 'UserHistory'
end
class UserHistory < ActiveRecord::Base
  act_as_log_of 'User'
end

describe 'Other Naming Model' do
  after(:all) { CreateAllTables.down }
  after do
    User.destroy_all
    UserHistory.destroy_all
  end

  let!(:user) do
    user  = User.create(name: 'name1')
    user.attributes = { name: 'name2' } ; user.save!
    user.attributes = { name: 'name3' } ; user.save!
    user
  end
  let!(:user_history) { user.logs.where(name: 'name1').first }

  describe User do
    subject { user }

    it { is_expected.to have_many(:logs).class_name('UserHistory') }
  end

  describe UserHistory do
    subject { user_history }

    it { is_expected.to belong_to(:originator).class_name('User') }
    its(:originator) { is_expected.to eq user }
  end
end
