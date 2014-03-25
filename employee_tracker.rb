require 'active_record'
require './lib/employee'
require './lib/division'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  input = nil
  until input == 'x'
    puts "'E' to access employee menu."
    puts "'D' to access division menu."
    puts "'P' to access projects menu."
    puts "'X' to exit."

    input = gets.chomp.downcase

    case input
    when 'e'
      employee_menu
    when 'p'
      project_menu
    when 'd'
      division_menu
    when 'x'
      puts "Goodbye!"
    else
      puts "Sorry try again"
    end
  end
end

def employee_menu
  list_employee
  puts "Enter the employee number to get more information."
  puts "Press 'a' to add an employee."
  puts "Press 'm' to return to main menu"
  user_input = gets.chomp
  case user_input
  when 'a'
    add_employee
  when 'm'
    main_menu
  else
    user_input = Employee.all[user_input.to_i - 1]
    employee_screen(user_input)
  end
end

def project_menu
end

def division_menu
end

def employee_screen(user_input)
  puts "#{user_input.name}'s Employee Screen."
  puts "Projects: #{user_input.projects}"
  puts "Division: #{user_input.division}"
  puts "Enter 'ap' to add a project."
  puts "Enter 'mp' to modify a project."
  puts "Enter 'ad' to add a division."
  puts "Enter 'md' to modify a division."
  puts "Enter 'd' to delete employee."
  puts "Enter 'b' to go back."
  input = gets.chomp
  case input
  when 'ap'
    add_project_employee(user_input)
  when 'mp'
    modify_project_employee(user_input)
  when 'ad'
    add_division_employee(user_input)
  when 'md'
    modify_division_employee(user_input)
  when 'd'
    user_input.destroy
    employee_menu
  else
    employee_menu
  end
end

def add_employee
  puts "Add employee's name"
  employee_name = gets.chomp
  puts " 'd' to add this employee to a division."
  puts " 'p' to assign a project to this employee."
  puts " 'x' to go back to main menu."
  user_input = gets.chomp
  case user_input
  when 'd'
    add_division_employee(employee_name)
  when 'p'
    add_project_employee(employee_name)
  when 'b'
    main_menu
  else
    puts "Sorry, wrong input. Try again."
    add_employee
  end
end

def add_division_employee(employee_name)
  list_division
  puts "What division does #{employee_name} belong to?"
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

def add_project_employee(employee_name)
  list_employee
  puts "Which employee do you want to add a project to?"
  employee_name = gets.chomp.to_i
  puts "What is the name of the project?"
  employee = Employee.all[employee_index - 1]
  employee.projects.new({:name => project_name, :done => false})
  employee.save
end

def list_employee
  Employee.all.each_with_index do |employee, index|
    puts "#{index + 1}: #{employee.name}"
  end
end

def add_project
  puts "Add a project."
  project_name = gets.chomp
  new_project = Project.new(:name => project_name)
  new_project.save
  puts "#{new_project.name} has been added."
end

def add_division
  puts "Add a division."
  division_name = gets.chomp
  new_division = Division.new(:name => division_name)
  new_division.save
  puts "#{new_division.name} has been added."
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

