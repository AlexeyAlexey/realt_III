class Hash

 def treeHash(hash)

     selfClone = self.clone
     hashInvert = hash.invert
       
     self.each do | key, value|   
         
        hashKeyValue = hashInvert.key value

        if hashKeyValue
          selfClone[key] = hashKeyValue
        end
        
     end #array.each

     selfClone
 end
 
end
