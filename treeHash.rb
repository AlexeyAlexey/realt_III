

class Hash

 def treeHash(*array)

     selfClone = self.clone
     hashResp = {} 
  
     array.each do |hash|   

        if selfClone.length >= hash.length
          then   
               selfClone.each_pair do |key, value|       
                  (hash.has_key? value) ? (hashResp[key] = hash[value]) : (hashResp[key] = value)
               end
      
          else
              selfInvert = selfClone.invert
                  hash.each_pair do |key, value|
                     if (selfInvert.has_key? key) then (hashResp[selfInvert[key]] = value) end    
                  end 

             hashResp = selfClone.merge hashResp
        end#if selfClone.length >= hash.length

        selfClone = hashResp.clone

    end #array.each

   hashResp

 end

 
end

#x1.treeHash x2, x3, x4
