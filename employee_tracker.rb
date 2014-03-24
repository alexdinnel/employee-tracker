require 'active_record'
require './lib/employee'
require './lib/division'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  input = nil
  until input == 'x'
    puts "'ae' to add an employee."
    puts "'le' to list out employees."
    puts "'de' to delete an employee."
    puts "'ad' to add an division."
    puts "'ld' to list out divisions."
    puts "'dd' to delete an division."
    puts "'x' to exit."

    input = gets.chomp

    case input
    when 'ae'
      add_employee
    when 'le'
      list_employee
    when 'de'
      delete_employee
    when 'ad'
      add_division
    when 'ld'
      list_division_menu
    when 'dd'
      delete_division
    when 'x'
      puts "Goodbye!"
    else
      puts "Sorry try again"
    end
  end
end

def add_employee
  puts "Add employee's name"
  employee_name = gets.chomp
  list_division
  puts "What division does the #{employee_name} belong to?"
  puts "Enter the number of the division or type in a new division."
  division_name = gets.chomp
  if (division_name.to_i.to_s == division_name) && (division_name.to_i <= Division.all.length)
    new_division = Division.all[division_name.to_i - 1]
  else
    new_division = Division.new({:name => division_name})
  end
  new_division.employees.new({:name => employee_name})
  new_division.save
end

def delete_employee
  list_employee
  puts "What employee do you want to delete?"
  employee_index = gets.chomp.to_i
  Employee.all[employee_index - 1].destroy
end

def list_employee
  Employee.all.each_with_index do |employee, index|
    puts "#{index + 1}: #{employee.name}"
  end
end

def add_division
  puts "Add a division."
  division_name = gets.chomp
  new_division = Division.new(:name => new_division)
  new_division.save
  puts "#{division_name.name} has been added."
end

def delete_division
  list_division
  puts "What division do you want to delete?"
  division_index = gets.chomp.to_i
  Division.all[division_index - 1].destroy
end

def list_division_menu
  list_division
  puts "Select a division to see more information."
  division_index = gets.chomp.to_i
  division_id = Division.all[division_index - 1].id
  employees = Employee.where(division_id: division_id)

  employees.each do |employee|
    puts employee.name
  end
end

def list_division
  Division.all.each_with_index do |division, index|
    puts "#{index + 1}: #{division.name}"
  end
end

main_menu

