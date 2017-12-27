require_relative "menus"
require_relative "globals"
require_relative "stats"

clear
title("CAR DEALERSHIP")
#sleep(4)
clear
Transaction.load_cars
Hr.load_staff
Stats.import

mainmenu

