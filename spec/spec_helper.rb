require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'division'
require 'employee'
require 'project'

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Division.all.each { |task| task.destroy }
  end
end
