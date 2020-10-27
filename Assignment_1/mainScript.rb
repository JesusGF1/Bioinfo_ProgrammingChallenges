require "./DatabaseObject.rb" #gene_information.tsv
require "./CrossObject.rb" #seed_stock_data.tsv
require "./GeneObject.rb" #cross_data.tsv

def linkage(parent1, parent2, chi_db, stock_db, gene_object) #the input is the name of the parents in seedstocks it should be the name of mutant_gene_id, the chisquare database. Now I should be able to relate the database of seedstock with the gene one
    par1 = gene_object.gene_name(parent1, stock_db) #stocks es la base de datos de seed_stocks
    par2 = gene_object.gene_name(parent2, stock_db)
    
    match_obj = Regexp.new(/\w+/) #creating a matchobject with the Regexp characteristic of the Gene_IDs
    if match_obj.match(par1) && match_obj.match(par2)
        if chi_db[parent1][parent2] >= 7.82
            puts "Recording: #{par1} is genetically linked to #{par2} with chisquare score #{chi_db[parent1][parent2]}" #
        else
            #puts "Recording: #{par1} is not genetically linked to #{par2} with chisquare score #{chi_db[parent1][parent2]}" #if you don't want the crosses that are not linked to show up you could just remove this line
        end
    else
        puts "The gene identifier format for #{parent1} or #{parent2} is not correct, please check the database"
    end
end


###Bloque del ejercicio 1
seed_stocks = Database.new
seed_stocks.load_from_file("#{ARGV[1]}") #Here i am loading seed_stock_data
stocks = seed_stocks.db #this object is the seed_stock_database

seed_stocks.plant("A334") #Here I am planting 7 of each type of seed (it is the default but it can be changed)if I wanted to do it automatically I could by iterating with the keys from the db
seed_stocks.plant("A348")
seed_stocks.plant("B3334")
seed_stocks.plant("A51")
seed_stocks.plant("B52")
seed_stocks.plant("A111") #this is my trial seed_stock, the name is A111 and it is the one I will have to prove that my first bonus works.

#seed_stocks.get_seed_stock("A51") #with this command you can access the information regarding A51

seed_stocks.write_database("#{ARGV[3]}") #writing the new database with the changes made and the newstockname

###Bloque del ejercicio 2
cross_object = HybridCross.new
cross_object.load_from_file("#{ARGV[2]}") #loading cross_data
cross_object.calc_chi_sq #calculating chi square for all the crosses
chi_sq_db = cross_object.chi_sq #saving the new hash with the parents as keys and the chi score as value
gene_obj = Gene.new
gene_obj.load_from_file("#{ARGV[0]}") #loading gene_information.tsv

linkage("A334", "A348", chi_sq_db, stocks, gene_obj)  #this would also be iterable with the keys from the gene database
linkage("A348", "B3334", chi_sq_db, stocks, gene_obj)
linkage("B3334", "A51", chi_sq_db, stocks, gene_obj)
linkage("A51", "B52", chi_sq_db, stocks, gene_obj) 
linkage("B52", "A334", chi_sq_db, stocks, gene_obj)
linkage("A111", "A334", chi_sq_db, stocks, gene_obj) #this one is for the trial with the wrong gene identifier name