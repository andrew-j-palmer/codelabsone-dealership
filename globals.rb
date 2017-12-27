########  VARIABLES  ################################################

#Array items for use throughout our program.

$staff = Array.new # Active Sales Staff
$cars = Array.new # Vehicles in Inventory
$totals = Array.new # Stats compiled by day

########  MENUS      ################################################

#Hashes used to build menus.

#MENU HASH STRUCTURE:                            
# { [title], [instructions], [prompt], [escape], [1,2,3] }
                                               

$mainmenu = {
    "title" => "MAIN MENU",
    "instructions" => "Select an action below by number.",
    "prompt" => "main> ",
    "escape" => "Save And Quit",
    "options" => [
      "Staff", 
      "Transactions", 
      "Reports"]
}

$staffmenu = {
    "title" => "STAFF",
    "instructions" => "Add to or Remove from Roster, or Exit to Main Menu",
    "prompt" => "staff> ",
    "escape" => "Exit to Main Menu",
    "options" => ["Add", "Remove"]
}

$transactionmenu = {
    "title" => "TRANSACTIONS",
    "instructions" => "Buy, Sell, Trade, or Service a vehicle.",
    "prompt" => "transactions> ",
    "escape" => "Exit to Main Menu",
    "options" => ["Buy", "Sell", "Trade", "Service"]
}

$statmenu = {
    "title" => "REPORTS & STATISTICS",
    "instructions" => "Pick an option from the menu to generate a report.",
    "prompt" => "stats> ",
    "escape" => "Exit to Main Menu",
    "options" => ["Vehicle Statistics", "Commision Totals", "Financials"]
}

#####################################################################