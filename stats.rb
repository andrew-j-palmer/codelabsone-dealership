#access to all sorts of stats
#daily totals or all-time totals

#CSV format: DAY|#SALES|$SALES|$COMMISION|#SERVICE|$SERVICE
module Stats

    def self.import(inputfile="totals.csv")
        File.readlines(inputfile).each do |line|
          day, sales, dollars, comm, services, service = line.split("|")
        @saleday = day
        @salenum += sales
        @saledollars += dollars
        @totalcomm += comm
        @numservice += services
        @dollarservice += service
        end
          $totals = {
              "day" => @saleday,
              "salenum" => @salenum,
              "saledollars" => @saledollars,
              "totalcomm" => @totalcomm,
              "numservice" => @numservice,
              "dollarservice" => @dollarservice
          }
      end
    
      def self.save(inputfile="totals.csv")
        File.open(inputfile, "w+") do |file|
          line = ($totals["day"] + 1 ).to_s + "|" + $totals["salenum"].to_s +
 "|" + $totals["saledollars"].to_s + "|" + $totals["totalcomm"].to_s +
 $totals["numservice"].to_s + "|" + $totals["dollarservice"]

          file.puts line
        end
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