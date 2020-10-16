require './DatabaseObject.rb'

seed_stocks = Database.new
seed_stocks.load_from_file
#puts seed_stocks.db
seed_stocks.plant("A334")
seed_stocks.plant("A348")
seed_stocks.plant("B3334")
seed_stocks.plant("A51")
seed_stocks.plant("B52")  
#puts seed_stocks.db
