class Database
    
    attr_accessor :db
    attr_accessor :path
    
    def initialize(db = {})
        @db = db #Hash will be a hash comprised of hashes.
    end
    
    def load_from_file(path = "./seed_stock_data.tsv")
      @path = path  #here we write the path of the file, if we wanted to see it outside the function we can acces it
      file_stocks = File.read(@path).split("\n") #We are reading the tsv, splitting by newline creates an array of strings, each string a line of the tsv
      @words =[]  #creating an array in which I will sall the words of the tsv
      for row in 0...file_stocks.length #iterating over the rows of the file.
        @words[row] = file_stocks[row].split("\t") #words is now an array of arrays. The first dimension of the array is the line, the second the column.
      end
    
      keys = Array.new #Now I am creating an array where I will save the keys that will allow me to access the inside hashes. This keys are the values of the seed_stock column of the tsv 
      for _ in 1...@words.length() #the range starts at one because I don't want Seed_stock located in words[0][0]
          keys[_-1] = @words[_][0] #I substract 1 to _ to start my indexes in key from 0 not from 1 as I would with this range. With the indexing in words I get the first column
      end
      
      lil_keys = @words[0][1...@words.length] #Here I create an array with the keys for the inside hashes, these are the words from the header except Seed_stock
      @db = Hash.new #I overwrite the initialized hash.
      counter = 0 #I am starting a counter that will allow me to convert the iteration through key in an index for the row number
      keys.each do |key|
          counter +=1  #increasing the counter in 1 so it starts at 1 before using it for the rows because I dont want the header row 
          @db[key] = Hash.new #I am creating a hash as the value pair for the keys I created earlier
          for i in 0...lil_keys.length
            if lil_keys[i] == "Grams_Remaining"  #Here I am setting an if else to account for the case of the number in the datbase so I can change it from a string to an integer
                @db[key][lil_keys[i]] =  @words[counter][i+1].to_i
            else
                @db[key][lil_keys[i]] =  @words[counter][i+1] #Filling the database hash, we fill a key with the different internal key-value pairs. The internal keys we get them from lil_keys and the values from words with fancy indexing. i is the index for lil_keys, if we add 1 it works for words too because we overlook the first column that corresponds to the keys.
    
            end  
          end
      end
    end
    
    def plant(seed_type, quantity=7) #seed type stands for the external key of the hash
        if @db[seed_type]["Grams_Remaining"] > quantity #if there is more seed left than what is planted we change the Grams_remaining in the quantity we planted
          @db[seed_type]["Grams_Remaining"] -= quantity
        else
          puts "WARNING: we have run out of seed stock #{seed_type}" #if there is else it ouputs an error
        
        end
    end
    
    def get_seed_stock(seed_type)
      puts "There are #{@db[seed_type]["Grams_Remaining"]} grams remaining of seed stock #{seed_type}" #I don't know if I should ask for grams remaining or the entire hash         
    end
    
    def write_database
      header = @words[0] #the header of the new tsv will be the first row of words from the beginning. Is an array of strings
      keys = @db.keys #the keys used to access the values are the keys from the database
      
      new_tsv = header.join("\t") # I am creating a new string object that contains the header words joined by tabs
      counter = 0  #initializing the counter that I will use to iterate over the keys array as a number
      for key in keys #using the key in keys to access the inside hashes
          linea = [] #initializing an array in which I will append the values from the inside array
          for value in @db[key].values # iterating over the values tso append them to linea
              linea.append(value.to_s)
          end
          new_tsv = new_tsv + "\n" + keys[counter] + "\t" + linea.join("\t")  #appending a new line to the append in each cycle
          counter += 1
      end
      File.open("new_stock_file.tsv", "w") { |f| f.write "#{new_tsv}" } #writting the tsv into a tsv file
    end
    
end