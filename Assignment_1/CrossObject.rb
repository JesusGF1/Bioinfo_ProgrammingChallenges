class HybridCross
    
    attr_accessor :db
    attr_accessor :chi_sq
    
    def initialize(db = {})
        @db = db #db will be a hash comprised of hashes inside of hashes. The first key will be parent 1, the second parent 2 and then the keys for each F2    end
    end 
     
     
    def load_from_file(path = "./cross_data.tsv")
      @path = path  #here we write the path of the file, if we wanted to see it outside the function we can acces it
      file_cross = File.read(@path).split("\n") #We are reading the tsv, splitting by newline creates an array of strings, each string a line of the tsv
      @words =[]  #creating an array in which I will sall the words of the tsv
      for row in 0...file_cross.length #iterating over the rows of the file.
        @words[row] = file_cross[row].split("\t") #words is now an array of arrays. The first dimension of the array is the line, the second the column.
      end
      
      @parents1 = Array.new #Now I am creating an array where I will save the keys that will allow me to access the inside hashes. This keys are the values of the parent1 column of the tsv 
      for _ in 1...@words.length() #the range starts at one because I don't want the word from the header located in words[0][0]
          @parents1[_-1] = @words[_][0] #I substract 1 to _ to start my indexes in key from 0 not from 1 as I would with this range. With the indexing in words I get the first column
      end
      
      @parents2 = Array.new
      for _ in 1...@words.length() #Same as with parents1 but for the second column of the tsv
          @parents2[_-1] = @words[_][1] 
      end
      
      f2_keys = @words[0][2...@words.length] #Here I create an array with the keys for the inside hashes, these are the words from the header regarding the f2_cross
      
      @db = Hash.new #I overwrite the initialized hash.
      counter = 0 #counter that will help me with the iterationtion through Parent 1 and 2 for the row number
      @parents1.each do |parent1| 
          @db[@parents1[counter]] = Hash.new #I am creating a hash as the value pair for the keys I created earlier
          @db[@parents1[counter]][@parents2[counter]] = Hash.new #another hash inside the keys of parents 2
          for i in 0...f2_keys.length #now i am iterating over the f2_keys array with the index to pair the header of the F2crosses as keys with their respective values
            @db[@parents1[counter]][@parents2[counter]][f2_keys[i]] =  @words[counter+1][i+2].to_f  #the counter and index modifications account for the differences in row and columns respectively.
          end
          counter +=1 
      end            
      
    end
    
    def calc_chi_sq
        
      observed = Array.new  #here I am creating different arrays that I will use to store the values of the operations needed to do the chisquare
      total = Array.new
      expected = Array.new
      chi_uniq = Array.new
      obs_exp = Array.new
      @chi_sq = Hash.new #in this hash I will store the chi_square value accesible by the parents names
      
      count = 0 #starting a counter to form a new array inside our previous arrays and to access the parents arrays to use their values as keys for @db
      for count in 0...@parents1.length
        
        observed[count] = Array.new  #initializing a new array in position count for observed. The same process will be repeated for upcoming operations
        total[count] = Array.new
        expected[count] = Array.new
        obs_exp[count]= Array.new
        chi_uniq[count] = Array.new
        @chi_sq[@parents1[count]] = Hash.new
        
        observed[count] = @db[@parents1[count]][@parents2[count]].values #extraction the observed f2 values for the descendance of a pair of parents
        total[count] = observed[count].sum #calculating the total number of observations by summing the values of the previous array
        expected[count]= [total[count]*9/16, total[count]*3/16, total[count]*3/16, total[count]*1/16 ] #creating a expected array with the values that represent our hypothesis of no linkage
        for i in 0...observed[0].length #new loop to iterate inside the previous arrays to operate with the observed expected pairs
            obs_exp[count][i] = observed[count][i] - expected[count][i]
            chi_uniq[count][i] = obs_exp[count][i]**2/expected[count][i]
        end 
        @chi_sq[@parents1[count]][@parents2[count]] = chi_uniq[count].sum #calculating the chi_square for each pair of parents   }
      end
      
    end

end