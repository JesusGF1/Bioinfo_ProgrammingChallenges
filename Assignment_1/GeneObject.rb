class Gene 
    attr_accessor :db
    def initialize(db = {})
      @db = db
    end
    
    def load_from_file(path = "./gene_information.tsv")
      @path = path  #here we write the path of the file, if we wanted to see it outside the function we can acces it
      file_gene = File.read(@path).split("\n") #We are reading the tsv, splitting by newline creates an array of strings, each string a line of the tsv
      @words =[]  #creating an array in which I will sall the words of the tsv
      for row in 0...file_gene.length #iterating over the rows of the file.
        @words[row] = file_gene[row].split("\t") #words is now an array of arrays. The first dimension of the array is the line, the second the column.
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
                @db[key][lil_keys[i]] =  @words[counter][i+1] #Filling the database hash, we fill a key with the different internal key-value pairs. The internal keys we get them from lil_keys and the values from words with fancy indexing. i is the index for lil_keys, if we add 1 it works for words too because we overlook the first column that corresponds to the keys.
          end
      end
    end

end