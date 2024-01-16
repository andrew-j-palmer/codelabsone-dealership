#init: name vehicle, new/used, cost, repairs. list price is computed.

#CSV FORMAT-> MAKE MODEL|N/U|COST
class Car
  attr_reader :model, :tradevalue, :type, :repairs
  attr_accessor :cost
  def initialize(model,type,value,repairs=0)
    @model = model
    @type = type.capitalize
    @cost = value.to_i + repairs.to_i
    @tradevalue = value.to_i - repairs.to_i 
    @repairs = repairs

  end

  def to_s
    "#{@type} #{@model} - $#{@cost}"
  end

  def to_csv
    @model.to_s + "|" + @type.to_s + "|" + @cost.to_s
  end

  def markup
    if @type == "Used"
      0.17
    else
      0.04
    end
  end

end