require 'spec_helper'

class TaskLog < ActiveRecord::Base; end
class Task < ActiveRecord::Base
  has_logs have_type: :duplicate
end
class TaskLog < ActiveRecord::Base
  act_as_log
end

describe 'Duplicate Model' do
  after(:all) { CreateAllTables.down }
  after do
    Task.destroy_all
    TaskLog.destroy_all
  end

  let!(:task) do
    task  = Task.create(name: 'name1')
    task.attributes = { name: 'name2' } ; task.save!
    task.attributes = { name: 'name3' } ; task.save!
    task
  end
  let!(:task_log) { task.logs.find_by(name: 'name2') }

  describe Task do
    subject { task }

    it { is_expected.to eq Task.find_by(name: 'name3') }
    it 'should have 3 logs' do
      expect(task.logs.count).to eq 3
    end
  end

  describe TaskLog do
    subject { task_log }
  end
end
