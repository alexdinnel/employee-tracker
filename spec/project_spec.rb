require 'spec_helper'

describe Project do
  it { should belong_to :employee }

  it 'returns projects that are not done' do
    not_done_projects = (1..2).to_a.map do |number|
      Project.create(:name => "task #{number}", :done => false)
    end
    done_project = Project.create(:name => 'done project', :done => true)
    Project.not_done.should eq not_done_projects
  end
  it 'returns projects that are done' do
    not_done_projects = (1..2).to_a.map do |number|
      Project.create(:name => "task #{number}", :done => false)
    end
    done_project = Project.create(:name => 'done project', :done => true)
    Project.done.should eq [done_project]
  end
end


