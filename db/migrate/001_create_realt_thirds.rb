class CreateRealtThirds < ActiveRecord::Migration

def up
   create_table(:realt_thirds, :primary_key => :idrealt_third)do |t|
       t.string  :reference,                :null => false
       t.string  :value_id,                 :null => false
       t.string  :valute,                   :null => false
       t.string  :host_name,                :null => false
       t.integer :priceMin,                 :null => false
       t.integer :priceMax,                 :null => false
              
   end
end


def down
   drop_table :realt_thirds
end

end
