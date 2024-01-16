require_relative 'globals'
require_relative 'inventory'
require_relative 'staff'
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
    cost = cost.gsub(/[$,]/, "")
    if type.upcase == "USED"
      repairs = Menu.menuprompt("Repairs Needed to sell? >$")
    else
      repairs = "0"
    end
    Menu.clear
    add = Menu.menuprompt( "Is this correct?\n#{type} #{model} - $#{cost} Cost, $#{repairs} repairs\nY/N> ")
    if add.upcase == "Y"
      Menu.clear
      @addcar = Car.new(model, type, cost, repairs)
      puts "Adding to inventory."
      $cars.push(@addcar)
      $daytotal.spentdollars += @addcar.cost
      if @addcar.repairs != "0"
        $daytotal.numservice += 1
        $daytotal.dollarservice += @addcar.repairs.to_i
      end
      sleep(1)
    elsif add.upcase == "N"
      puts "Cancelled Transaction."
      sleep(1)
      Menu.clear
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
        sleep(1.5)
        puts "The target price for this vehicle is $#{$cars[@removecar].cost * $cars[@removecar].markup + $cars[@removecar].cost}."
        sleep(1)
        @saleprice = Menu.menuprompt("Sale Price: $")
        #If trading, subtract trade-in value, then reset trade-in value to zero
        if $trade == true        
          @cost = @cost - $tradevalue
          puts "(Dropping price by trade-in value of $#{$tradevalue})"
          $trade = false
          $tradevalue = 0
          sleep(1.5)
        end
        Menu.clear
        puts "Sales Staff:"
        count = 1
        $staff.each do |x|
          puts "#{count}. #{x}"
          count += 1
        end
        staffsale = Menu.menuprompt("Select staff member who made the sale: ")
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
            $daytotal.totalcomm += @comm
            $daytotal.salenum += 1
            $daytotal.saledollars += @saleprice
            $cars.delete_at(@removecar)
            puts "#{$staff[index].name} made $#{@comm} commission on the sale. Well done!"
            sleep(3)
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

  def self.tradecar
    tradecarmenu = {
      "title" => "TRADE VEHICLE",
      "instructions" => "To trade, we first want to enter the trade vehicle into inventory. Then, we will apply the trade value towards the sale.",
      "prompt" => "",
      "escape" => "Press Enter to continue or enter '1' to cancel.",
      "options" => []
    }
    #trade variable tells sellcar menu to subtract trade-in value
    $trade = true
    input = Menu.menu(tradecarmenu)
    if input == "1"
      Menu.transactions
    elsif input == ""
      Transaction.buycar
      $tradevalue = @addcar.tradevalue.to_i
      Transaction.sellcar
      Menu.transactions
    else
      Menu.lastmenu
      Menu.transactions
    end
  end

  def self.service
    servicemenu= {
      "title" => "SERVICE VEHICLE",
      "instructions" => "Choose from a list of services below, or select other to enter a service not listed.",
      "prompt" => "Service> ",
      "escape" => "Cancel",
      "options" => [ "Body Shop/Glass", "Brake Job", "Chassis Lube", "Emissions System Testing/Service",
 "Detail Shop/Interior", "Engine Service/Repair", "Heat/A/C Services", "Oil Change", "Suspension Service/Repair",
 "Tires", "Transmission Repair/Service", "Tune-Up", "Other"]
    }
    input = Menu.menu(servicemenu)
    if Menu.digitfilter(input) == true
      input = input.to_i
      case 
      when input <= 0
        #error invalid
        Menu.lastmenu
        Menu.menu(servicemenu)
      when input < servicemenu["options"].size
        index = input -1
        Menu.clear
        Menu.title(servicemenu["options"].at(index).upcase)
        serviceamt =  Menu.menuprompt("Enter dollar amount of parts and labor: $")
        $daytotal.numservice += 1
        $daytotal.dollarservice += serviceamt.to_i
        Menu.clear
        puts "Adding $#{serviceamt} to daily Service totals."
        sleep(2)
        Menu.transactions
      when input == servicemenu["options"].size
        index = input -1
        Menu.clear
        Menu.title(servicemenu["options"].at(index).upcase)
        description = Menu.menuprompt("Enter description of services: ")
        serviceamt =  Menu.menuprompt("Enter dollar amount of parts and labor: $")
        $daytotal.numservice += 1
        $daytotal.dollarservice += serviceamt.to_i
        Menu.clear
        puts "Adding $#{serviceamt} to daily Service totals."
        sleep(2)
        Menu.transactions
      when input == servicemenu["options"].size + 1
        #cancel
        puts "Cancelling Transaction."
        sleep(1)
        Menu.transactions
      else
        #error invalid
        Menu.lastmenu
        Menu.menu(servicemenu)
      end
    end
  end
end