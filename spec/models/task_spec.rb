require 'spec_helper'

describe "Task Model" do
  let(:task) { Task.new }
  it 'can be created' do
    task.should_not be_nil
  end
end
