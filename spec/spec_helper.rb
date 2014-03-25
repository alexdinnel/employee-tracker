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
    Division.all.each { |division| division.destroy }
    Employee.all.each { |employee| employee.destroy }
    Project.all.each { |project| project.destroy }
  end
end
