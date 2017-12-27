require_relative 'transactions'

#All the menus for the app.

def clear
  # Clears screen. Just to pretty things up a little
  # Windows users switch out `clear` for `cls`
  puts `clear`
end
   
def title(text)
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
    
def menu(params)
  # Modular menu builder. I doubt this will be of use in
  # the more specialized menus deeper in the tree

  @lastmenu = params
  title(params["title"])
  count = 1
  puts "\n"
  puts params["instructions"]
  puts "\n\n"
  params["options"].each do |x|
    puts "#{count}. #{x.to_s}  "
    count += 1
  end
  puts "#{count}. #{params["escape"]}"
  puts "\n"
  menuprompt(params["prompt"])

end
    
def menuprompt(text)
  #consistent prompt and input method for menus
  print text
  gets.chomp
end

def confirm(text)
  #return true/false. Used as an Undo for entry/execution mistakes
  puts text
  input = menuprompt("Y/N: ")
  if input.upcase == "Y"
    true
  elsif input.upcase == "N"
    false
  end
end

def lastmenu
  # Menu error catching and redirect. Won't work correctly
  # without logic in menu method. Still, I can't believe this works
  clear
  puts "You need to enter a number that matches one of the menu options."
  sleep(2)
  input = menu(@lastmenu)
end

def digitfilter(input)
  # return T/F on whether input is a number. Used for menus.
  if /^[1-9]+$/.match(input) != nil
    true
  else
    false
  end
end

#######  MENU SCREENS    ############################################

# I don't think these are going to get any more modular
# Build menu with menu method and hash, then determine 
# next menu to display with case statement
def mainmenu  
  input = menu($mainmenu)

  case input
  when "1"
    staffmenu
  when "2"
    transactionmenu
  when "3"
    statmenu
  when "4"
    clear
    puts "Saving and Exiting..."
    sleep(1)
    Transaction.save_cars
    Hr.save_staff
    Stats.save
  else
    lastmenu
    mainmenu
  end
end

def staffmenu
  input = menu($staffmenu)

  case input
  when "1"
    Hr.addstaff
  when "2"
    Hr.downsize
  when "3"
    mainmenu
  else
    lastmenu
    staffmenu
  end
end

def transactionmenu
  input = menu($transactionmenu)

  case input
  when "1"
    Transaction.buycar
  when "2"
    Transaction.sellcar
  when "3"
    Transaction.tradecar
  when "4"
    Transaction.service
  when "5"
    mainmenu
  else
    lastmenu
    transactionmenu
  end
end

def statmenu
  title("REPORTS & STATISTICS")
  puts "\n"
  puts "Daily or All-Time statistics?\n\n"
  puts "\n\n"
  puts "1. Daily"
  puts "2. All-Time\n\n\n"

  input = menuprompt("stats> ")
  case input
  when "1"
    @allstats = 0
  when "2"
    @allstats = 1
  else
    lastmenu
    statmenu
  end

  input = menu($statmenu)

  case input
  when "1"
    Stats.vehicletotals
  when "2"
    Stats.commision
  when "3"
    Stats.top_and_bottom_lines
  when "4"
    mainmenu
  else
    lastmenu
    statmenu
  end
end
