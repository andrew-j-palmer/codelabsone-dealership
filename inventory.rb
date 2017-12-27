#init: name vehicle, new/used, cost, repairs. list price is computed.

#CSV FORMAT-> MAKE MODEL|N/U|COST
class Car
  attr_reader :model
  attr_accessor :cost
  def initialize(model,type,cost,repairs=0)
    @model = model
    @type = type
    @cost = cost.to_i + repairs.to_i

  end

  def to_s
    "#{@type} #{@model} - $#{@cost.to_s}"
  end

  def to_csv
    @model + "|" + @type + "|" + @cost.to_s
  end

  def type
    @type
  end

  def markup
    if @type == "Used"
      0.17
    else
      0.04
    end
  end

end