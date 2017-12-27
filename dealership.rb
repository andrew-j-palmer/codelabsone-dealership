require_relative "menus"
require_relative "globals"
require_relative "stats"

# Splash screen
clear
title("CAR DEALERSHIP")
#sleep(4)
clear

# Load any cars that may be saved in inventory
Transaction.load_cars

# Load any staff that may be saved
Hr.load_staff

# Attempt to load previous stats, if they exist
Stats.import

# Create empty single-day stat object
$total = Total.new

# Jump into main menu, everything else should be accessible from there
mainmenu

