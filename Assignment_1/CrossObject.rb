class HybridCross
    
    attr_accessor :db

    def initialize(db = {})
        @db = db #db will be a hash comprised of hashes inside of hashes. The first key will be parent 1, the second parent 2 and then the keys for each F2    end
    end 
     
     
    def load_from_file(path = "./cross_data.tsv")
      @path = path  #here we write the path of the file, if we wanted to see it outside the function we can acces it
      file_stocks = File.read(@path).split("\n") #We are reading the tsv, splitting by newline creates an array of strings, each string a line of the tsv
      @words =[]  #creating an array in which I will sall the words of the tsv
      for row in 0...file_stocks.length #iterating over the rows of the file.
        @words[row] = file_stocks[row].split("\t") #words is now an array of arrays. The first dimension of the array is the line, the second the column.
      end
      
      parents1 = Array.new #Now I am creating an array where I will save the keys that will allow me to access the inside hashes. This keys are the values of the parent1 column of the tsv 
      for _ in 1...@words.length() #the range starts at one because I don't want the word from the header located in words[0][0]
          parents1[_-1] = @words[_][0] #I substract 1 to _ to start my indexes in key from 0 not from 1 as I would with this range. With the indexing in words I get the first column
      end
      
      parents2 = Array.new
      for _ in 1...@words.length() #Same as with parents1
          parents2[_-1] = @words[_][1] 
      end
      
      f2_keys = @words[0][2...@words.length] #Here I create an array with the keys for the inside hashes, these are the words from the header regarding the f2_cross
      
=begin      
      puts parents1[0]
      puts ""
      puts parents2[0]
      puts ""
      puts f2_keys[0]
=end
      
      @db = Hash.new #I overwrite the initialized hash.
      counter = 0 #counter that will help me with the iterationtion through Parent 1 and 2 for the row number
      parents1.each do |parent1| 
          @db[parents1[counter]] = Hash.new #I am creating a hash as the value pair for the keys I created earlier
          @db[parents1[counter]][parents2[counter]] = Hash.new
          for i in 0...f2_keys.length
            @db[parents1[counter]][parents2[counter]][f2_keys[i]] =  @words[counter+1][i+2].to_f
          end
          counter +=1 
      end
      
      #puts @db
    
    end

    def chi_square(p1, p2)
        @p1 = p1
        @p2 = p2
        
        observed= @db[@p1][@p2].values
        total = observed.sum
        expected = Array.new
        expected = [total*9/16, total*3/16, total*3/16, total*1/16 ]
        
        chi_uniq = Array.new
        obs_exp = Array.new
        for _ in 0...observed.length
            obs_exp[_] = observed[_]-expected[_]
            chi_uniq[_] = obs_exp[_]**2/expected[_]
        end
        chi_sq = chi_uniq.sum
        puts chi_sq
    
    end
    
end