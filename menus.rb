require_relative 'transactions'

# Tools for building menus. At the bottom are the app main menus.
module Menu

  def self.clear
    # Clears screen. Just to pretty things up a little
    # Windows users switch out `clear` for `cls`
    puts `clear`
  end
      
  def self.title(text)
    # A little razzle dazzle just because I'm bored
    bar = ""
    lines = []
    lines[0] = bar.center(60, "*")  
    lines[1] = "**" + text.center(56, " ") + "**"
    lines[2] = bar.center(60, "*")
    lines[3] = "\n"

    line = lines.join("\n")
    clear
    184.times do |x|
      print line[x]
      sleep(0.002)
    end
  end
        
  def self.menu(params)
    # Modular menu builder. I doubt this will be of use in
    # the more specialized menus deeper in the tree

    @lastmenu = params
    Menu.title(params["title"])
    count = 1
    puts "\n"
    puts params["instructions"]
    puts "\n\n"
    params["options"].each do |x|
      option = count.to_s + "."
      puts "#{option.rjust(3, " ")} #{x}  "
      count += 1
    end
    puts (count.to_s + ".").rjust(3, " ") + " #{params["escape"]}"
    puts "\n"
    Menu.menuprompt(params["prompt"])

  end
        
  def self.menuprompt(text)
    #consistent prompt and input method for menus
    print text
    gets.chomp
  end

  def self.confirm(text)
    #return true/false. Used as an Undo for entry/execution mistakes
    puts text
    input = menuprompt("Y/N: ")
    if input.upcase == "Y"
      true
    elsif input.upcase == "N"
      false
    end
  end

  def self.lastmenu
    # Menu error catching and redirect. Won't work correctly
    # without logic in menu method. Still, I can't believe this works
    clear
    puts "You need to enter a number that matches one of the menu options."
    sleep(2)
    input = menu(@lastmenu)
  end

  def self.digitfilter(input)
    # return T/F on whether input is a number. Used for menus.
    if /^\d+$/.match(input) != nil
      true
    else
      false
    end
  end

#######  MENU SCREENS    ############################################

# I don't think these are going to get any more modular
# Build menu with menu method and hash, then determine 
# next menu to display with case statement
  def self.main  
    input = menu($mainmenu)

    case input
    when "1"
      Menu.staff
    when "2"
      Menu.transactions
    when "3"
      Menu.stats
    when "4"
      clear
      puts "Saving and Exiting..."
      sleep(1)
      Transaction.save_cars
      Hr.save_staff
      Stats.save
      exit(true)
    else
      Menu.lastmenu
      Menu.main
    end
  end

  def self.staff
    input = Menu.menu($staffmenu)

    case input
    when "1"
      Hr.addstaff
    when "2"
      Hr.downsize
    when "3"
      Menu.main
    else
      Menu.lastmenu
      Menu.staff
    end
  end

  def self.transactions
    input = Menu.menu($transactionmenu)

    case input
    when "1"
      Transaction.buycar
      Menu.transactions
    when "2"
      Transaction.sellcar
      Menu.transactions
    when "3"
      Transaction.tradecar
      Menu.transactions
    when "4"
      Transaction.service
      Menu.transactions
    when "5"
      Menu.main
    else
      Menu.lastmenu
      Menu.transactions
    end
  end

  def self.stats
    Menu.title("REPORTS & STATISTICS")
    puts "\n"
    puts "Daily or All-Time statistics?\n\n"
    puts "\n\n"
    puts "1. Daily"
    puts "2. All-Time"
    puts "3. Return to Main Menu\n\n"

    input = Menu.menuprompt("stats> ")
    case input
    when "1"
      $alltimestats = false
    when "2"
      $alltimestats = true
    when "3"
      Menu.main
    else
      Menu.lastmenu
      Menu.stats
    end

    input = Menu.menu($statmenu)

    case input
    when "1"
      Stats.vehicletotals
    when "2"
      Stats.commision
    when "3"
      Stats.top_and_bottom_lines
    when "4"
      Menu.main
    else
      Menu.lastmenu
      Menu.stats
    end
  end
end