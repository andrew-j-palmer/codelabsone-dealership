# $totals CSV format: DAY|#SALES|$SALES|$COMMISION|#SERVICE|$SERVICE


class Total
# Stat object. A single object contains the stats for the day, $totals array contains
# all-time stats (initialized in globals.rb, loaded and saved by Stats Module)
  attr_accessor :saleday, :salenum, :saledollars, :totalcomm, :numservice, :dollarservice

  def initialize(saleday=0,salenum=0,saledollars=0,totalcomm=0,numservice=0,dollarservice=0)
    @saleday = saleday.to_i
    @salenum = salenum.to_i
    @saledollars = saledollars.to_i
    @totalcomm = totalcomm.to_i
    @numservice = numservice.to_i
    @dollarservice = dollarservice.to_i
  end


end

module Stats

  def self.import(inputfile="totals.csv")
    File.readlines(inputfile).each do |line|
      day, sales, dollars, comm, services, service = line.split("|")
      total = Total.new()
      $totals.push(total)
    end
  end
    
  def self.save(inputfile="totals.csv")
    File.open(inputfile, "w+") do |file|
      line = ($totals.size + 1 ).to_s + "|" + $total.salenum.to_s + "|" + 
$total.saledollars.to_s + "|" + $total.totalcomm.to_s + $total.numservice.to_s + 
"|" + $total.dollarservice.to_s
      puts "printing" + line
      file.puts line
    end
  end

  def self.vehicletotals(total)

  end

  def self.commision(total)

  end

  def self.top_and_bottom_lines(total)

  end

#daily
#num/$ totals sold by agent
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