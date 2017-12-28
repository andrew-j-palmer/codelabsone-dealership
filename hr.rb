#Staff and roster management tools.
require_relative 'staff'
require_relative 'globals'
require_relative 'menus'

module Hr

  def self.load_staff(inputfile="staff.csv")
    File.readlines(inputfile).each do |line|
      name, salenum, saledollars, totalcomm = line.split("|")
      x = Staff.new(name, salenum, saledollars, totalcomm)
      $staff.push(x)
    end
  end

  def self.save_staff(inputfile="staff.csv")
    File.open(inputfile, "w+") do |file|
      $staff.each do |staff|
        file.puts staff.to_csv
      end
    end
  end

  def self.addstaff
    Menu.title("ADD STAFF")
    puts "Welcome aboard! What is the name of our new sales agent?"
    input = Menu.menuprompt("Name: ")
    Menu.clear
    sleep(1)
    execute = Menu.confirm("Add '#{input}' to roster?")
    if execute == true
      agent = Staff.new(input)
      $staff.push(agent)
      puts "Great! Added to sales roster."
      puts $agent
      sleep(1)
      Menu.staff
    elsif execute == false
      puts "Cancelled."
      sleep(1)
      Menu.staff
    else
      puts "Input not understood. Reverting to Staff Menu."
      sleep(2)
      Menu.staff
    end
  end

  def self.downsize
    downsizemenu = {
      "title" => "REMOVE STAFF",
      "instructions" => "Select the number next to the agent to be removed.",
      "prompt" => "agent> ",
      "escape" => "cancel",
      "options" => $staff
    }
    
    input = Menu.menu(downsizemenu)
    # logic borrowed from "sell car" menu

    # filter input
    if Menu.digitfilter(input) == true
      input = input.to_i
      case 
      when input <= 0
        #error invalid
        Menu.lastmenu
        Menu.menu(downsizemenu)
      when input <= $staff.size
        index = input -1
        execute = Menu.confirm("Remove agent #{$staff[index].name}?")
        if execute == true
          puts "So long, #{$staff[index].name}! We thank you for your work."
          $staff.delete_at(index)
          sleep(2)
          Menu.staff
        elsif execute == false
          puts "Cancel Removal."
          sleep(2)
          Menu.staff
        else
          puts "Input not understood. Reverting to Staff menu."
          sleep(2)
          Menu.staff
        end
      when input == $staff.size + 1
        #cancel
        Menu.staff
      when input > $staff.size + 1
        #error out of range
        Menu.lastmenu
        input = Menu.menu(downsizemenu)
      end
    elsif Menu.digitfilter(input) == false
      #error bad input
      Menu.lastmenu
      input = Menu.menu(downsizemenu)
    end
  end

end