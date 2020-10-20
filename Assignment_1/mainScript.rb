require "./#{ARGV[0]}" #database object
require "./#{ARGV[1]}" #Crossobject
require "./#{ARGV[2]}" #GeneObject

def linkage(parent1, parent2, chi_db, stock_db, gene_object) #the input is the name of the parents in seedstocks it should be the name of mutant_gene_id, the chisquare database. Now I should be able to relate the database of seedstock with the gene one
    par1 = gene_object.gene_name(parent1, stock_db) #stocks es la base de datos de seed_stocks
    par2 = gene_object.gene_name(parent2, stock_db)
    
    if chi_db[parent1][parent2] >= 7.82
      puts "#{par1} is genetically linked to #{par2}"
    else
      puts "#{par1} is not genetically linked to #{par2}"
    end
end


###Bloque del ejercicio 1
seed_stocks = Database.new
seed_stocks.load_from_file
stocks = seed_stocks.db

seed_stocks.plant("A334") #Here I am planting 7 of each type of seed if I wanted to do it automatically I could iterating with the keys from the db
seed_stocks.plant("A348")
seed_stocks.plant("B3334")
seed_stocks.plant("A51")
seed_stocks.plant("B52")  
seed_stocks.get_seed_stock("A51") #with this command you can access the information regarding A51
seed_stocks.write_database #writing the new database with the changes made

###Bloque del ejercicio 2
cross_object = HybridCross.new
cross_object.load_from_file
cross_object.calc_chi_sq
chi_sq_db = cross_object.chi_sq
gene_obj = Gene.new
gene_obj.load_from_file

linkage("A334", "A348", chi_sq_db, stocks, gene_obj)  #sobre esto también podría iterar para automatizarlo
linkage("A348", "B3334", chi_sq_db, stocks, gene_obj)
linkage("B3334", "A51", chi_sq_db, stocks, gene_obj)
linkage("A51", "B52", chi_sq_db, stocks, gene_obj)
linkage("B52", "A334", chi_sq_db, stocks, gene_obj)
