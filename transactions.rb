require_relative 'globals'
require_relative 'inventory'
require_relative 'staff'
require_relative 'hr'
require_relative 'menus'

module Transaction


  def self.load_cars(inputfile="inventory.csv")
    File.readlines(inputfile).each do |line|
      model, type, cost = line.split("|")
      x = Car.new(model,type,cost)
      $cars.push(x)
    end
  end

  def self.save_cars(inputfile="inventory.csv")
    File.open(inputfile, "w+") do |file|
      $cars.each do |car|
        file.puts car.to_csv
      end
    end
  end

  def self.buycar
    Menu.title("BUY INVENTORY")
    puts "We need some information about this vehicle. Fill out the "
    puts "prompts when, you know, prompted."
    puts "\n"
  
    model = Menu.menuprompt("Make/Model? > ")
    type = Menu.menuprompt("New/Used? > ")
    cost = Menu.menuprompt("Cost? >$")
    if type == "Used"
      repairs = Menu.menuprompt("Repairs Needed to sell? >$")
    else
      repairs = "0"
    end
    Menu.clear
    add = Menu.menuprompt( "Is this correct?\n#{type} #{model} - $#{cost} Cost, $#{repairs} repairs\nY/N> ")
    if add.upcase == "Y"
      Menu.clear
      addcar = Car.new(model, type, cost, repairs)
      puts "Adding to inventory."
      $cars.push(addcar)
      $total.spentdollars += addcar.cost
      sleep(1)
      Menu.transactions
    elsif add.upcase == "N"
      puts "Cancelled Transaction."
      sleep(1)
      clear
      Menu.transactions
    else
      Menu.lastmenu
      Menu.transactions
    end
  end

  def self.sellcar
    sellcarmenu = {
      "title" => "SELL INVENTORY",
      "instructions" => "Select the number next to the vehicle to be sold.",
      "prompt" => "vehicle> ",
      "escape" => "cancel",
      "options" => $cars
    }
    input = Menu.menu(sellcarmenu)
    # I have no idea how many cars there may be in inventory, so
    # I can't have a hard-coded case statement. This is going to be
    # tricky.

    #filter input
    if Menu.digitfilter(input) == true
      input = input.to_i
      case 
      when input <= 0
        #error invalid
        Menu.lastmenu
        Menu.menu(sellcarmenu)
      when input <= $cars.size
        @removecar = input -1
        @cost = $cars[@removecar].cost
        puts "SELLING #{$cars[@removecar].to_s}"
        sleep(1)
        puts "as a #{$cars[@removecar].type} vehicle, it can be sold at a #{$cars[@removecar].markup * 100} percent markup."
        sleep(2)
        puts "The target price for this vehicle is $#{$cars[@removecar].cost * $cars[@removecar].markup + $cars[@removecar].cost}."
        sleep(2)
        
        @saleprice = Menu.menuprompt("Sale Price: $")
        Menu.clear
        puts "Sales Staff:"
        count = 1
        $staff.each do |x|
          puts "#{count}. #{x}"
          count += 1
        end
        staffsale = Menu.menuprompt("Staff member who made the sale: ")
        if Menu.digitfilter(staffsale) == true
          input = staffsale.to_i
          @saleprice = @saleprice.to_i
          case 
          when input <= 0
            #error invalid
            Menu.lastmenu
            Menu.menu(sellcarmenu)
          when input <= $staff.size
            index = input - 1
            $staff[index].salenum += 1
            $staff[index].saledollars += @saleprice
            # Staff make a minimum of 100 dollars per sale, even at a loss.
            # Additional commision is earned at 8 percent of profit.
            @comm = 100
            if @saleprice > @cost
              @comm += (@saleprice - @cost) * 0.08
            end
            $staff[index].totalcomm += @comm
            $total.totalcomm += @comm
            $total.salenum += 1
            $total.saledollars += @saleprice
            $cars.delete_at(@removecar)
            puts "#{$staff[index].name} made $#{@comm} commission on the sale. Well done!"
            sleep(3)
            Menu.transactions
          when input > $staff.size
            puts "Seriously, you need to be more careful. It's too hard
 to filter all this input. Cancelling sale."
            sleep(2)
            Menu.transactions
          end
        end

      when input == $cars.size + 1
        #cancel
        Menu.transactions
      when input > $cars.size + 1
        #error out of range
        Menu.lastmenu
        input = Menu.menu(sellcarmenu)
      end
    elsif Menu.digitfilter(input) == false
      #error bad input
      Menu.lastmenu
      input = Menu.menu(sellcarmenu)
    end
  end
end