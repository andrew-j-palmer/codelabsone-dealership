#load roster, keep stats on staff

#CSV format: NAME|SALES#|SALES$|COMMISION

class Staff
  attr_accessor :name, :salenum, :saledollars, :totalcomm

  def initialize(name,saletotal=0,saledollar=0,comm=0)
    @name = name
    @salenum = saletotal.to_i
    @saledollars = saledollar.to_i
    @totalcomm = comm.to_i
  end

  def to_s
    "#{@name} - #{@salenum} Sales totalling $#{@saledollars}"
  end

  def to_csv
    @name + "|" + @salenum.to_s + "|" + @saledollars.to_s + "|" + @totalcomm.to_s
  end

end