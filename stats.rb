# $totals CSV format: DAY|#SALES|$SPENT|$SALES|$COMMISION|#SERVICE|$SERVICE


class Total
# Stat object. A single object contains the stats for the day, $totals array contains
# all-time stats (initialized in globals.rb, loaded and saved by Stats Module)
  attr_accessor :saleday, :salenum, :spentdollars, :saledollars, :totalcomm, :numservice, :dollarservice

  def initialize(saleday=0,salenum=0,spentdollars=0,saledollars=0,totalcomm=0,numservice=0,dollarservice=0)
    @saleday = saleday.to_i
    @salenum = salenum.to_i
    @spentdollars = spentdollars.to_i
    @saledollars = saledollars.to_i
    @totalcomm = totalcomm.to_i
    @numservice = numservice.to_i
    @dollarservice = dollarservice.to_i
  end


end

module Stats

  def self.import(inputfile="totals.csv")
    File.readlines(inputfile).each do |line|
      day, sales, spent, dollars, comm, services, service = line.split("|")
      total = Total.new(day,sales,spent,dollars,comm,services,service)
      $totals.push(total)
    end
  end
    
  def self.save(inputfile="totals.csv")
    File.open(inputfile, "a+") do |file|
      line = ($totals.size + 1 ).to_s + "|" + $total.salenum.to_s + "|" +
 $total.spentdollars.to_s + "|" + $total.saledollars.to_s + "|" + $total.totalcomm.to_s +
 "|" + $total.numservice.to_s + "|" + $total.dollarservice.to_s
      puts "saved stats: " + line
      file.puts line
    end
  end

  def self.all_time
    @figures = $total
    @figures.saleday = $totals.size
    if $alltimestats == true
      $totals.each do |x|
        @figures.salenum += x.salenum.to_i
        @figures.spentdollars += x.spentdollars.to_i
        @figures.saledollars += x.saledollars.to_i
        @figures.totalcomm += x.totalcomm.to_i
        @figures.numservice += x.numservice.to_i
        @figures.dollarservice += x.dollarservice.to_i
      end
      @state = "ALL-TIME "
      @line = "Over #{@figures.saleday} days:\n"
    else
      @state = "DAILY "
      @line = "For day #{@figures.saleday}:\n"
    end
  end

  def self.vehicletotals
    Stats.all_time
    Menu.clear
    sleep(1)
    Menu.title("#{@state}VEHICLE STATISTICS")
    puts @line
    puts "Number of vehicles sold: #{@figures.salenum}"
    puts "Dollar amount of vehicles sold: $#{@figures.saledollars}"
    puts "Number of services performed in Service Center: #{@figures.numservice}"
    puts "Dollar amount of services performed in Service Center: $#{@figures.dollarservice}"
    sleep(3)
    puts "\n\n\n"
    input = Menu.menuprompt("(Press Enter to return to Reports/Statistics)\n\n")
    Menu.stats
  end

  def self.commision
    Stats.all_time
    Menu.title("#{@state}COMMISION FIGURES")
    puts @line
    puts "Total commision paid out: $#{@figures.totalcomm} from #{@figures.salenum} vehicle sales"
    puts "Average commision paid per vehicle: $#{@figures.totalcomm / @figures.salenum}"
    sleep (3)
    puts "\n\n\n\n"
    Menu.menuprompt("(Press Enter to return to Reports/Statistics)\n\n")
    Menu.stats
  end

  def self.top_and_bottom_lines
    Stats.all_time
    Menu.title("FINANCIALS")
    puts @line
    @revenue = @figures.saledollars + @figures.dollarservice
    @expenditures = @figures.spentdollars + @figures.totalcomm
    puts "Total Revenue: #{@revenue}"
    puts "(#{@figures.salenum} vehicle sales and #{@figures.numservice} Services performed)"
    puts ""
    puts "Total Expenditures: #{@expenditures}"
    puts "(Vehicles brought into inventory, repairs on vehicles currently in inventory)"
    puts "\n\n"
    sleep(3)
    puts "Balance: $#{@revenue - @expenditures}"
    sleep(1)
    Menu.menuprompt("(Press Enter to return to Reports/Statistics)\n\n")
    Menu.stats
  end

#daily
#num/$ totals sold
#num/$ totals bought
#num/$ totals service

#commision paid
#revenue
#expenditures
#$ profit/ profit margin




#all-time
#num/$ totals sold
#num/$ totals bought
#num/$ totals service

#total commision paid
#total revenue
#total expenditures
#$ profit/profit margin

end