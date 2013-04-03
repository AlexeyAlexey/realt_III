#!ruby --encoding=cp1251
#coding: UTF-8

require 'open-uri' 
require 'fileutils'
require 'active_record'
require 'action_mailer'
require 'yaml'
require 'erb'

Dir.chdir(File.dirname File.expand_path('../realtSite.rb', __FILE__))

require './treeHash.rb'

ActiveRecord::Base.establish_connection YAML.load_file('db.yaml')
  
class RealtThird < ActiveRecord::Base
end

ActionMailer::Base.smtp_settings = YAML.load_file('mailer.yaml')

class MailRealt < ActionMailer::Base
 self.default :from => "ialexey.kondratenko@gmail.com", :charset => "Windows-1251"
 
 def welcome(recipient, msg)

	 mail(:to => recipient, :subject => "RealtReport 2 file on the https://github.com/AlexeyAlexey/realt_II sum in dollars between 0 and 300") do |format|	      
            format.text { render :text => msg}
         end  
 end
 
end

class HTMLrealt

DBSites = YAML.load_file('dbSitesII.yaml')

attr_reader :msg

private 
    
   def str_html 
      uri = URI.parse @urlSite
      uri.read      
   end
   
  
public

   def setProperty(site)
      
      @site = DBSites[site]
      @headSite = @site["scheme"] + "://" + @site["hostName"] + "/" 

      hashValue = @site["hashValue"]  
      @head = hashValue.treeHash @site["typValute"]
      @msg = "Site: #{@site["hostName"]}   priceMin: #{@head["priceMin"]}   priceMax: #{@head["priceMax"]}   valute: #{@head["valute"]} \n" 
      path = ERB.new(@site["resourcePath"])      
      @urlSite = @headSite + path.result(binding)
      
   end

   def catchPage
       
         str_html.each_line do |str|
            res = @site["regexpr"].match str
            
            if res
              then                  
                  if !RealtThird.where(:value_id => res[2], :host_name => @site["hostName"]).exists?
                    then 
                        id_res = res[2]
                        source = @headSite + (ERB.new(@site["resourcePath2"])).result(binding)
                        RealtThird.create(:reference => source, 
                                          :value_id  => res[2],
                                          :valute    => @head["valute"],
                                          :host_name => @site["hostName"],
                                          :priceMin  => @head["priceMin"],
                                          :priceMax  => @head["priceMax"])                        
                        @msg = @msg + " - " + source + "\n"                                      
                  end                  
            end

         end#str_html      
      (@msg = @msg + "Nothing") if @msg == ""      
   end

end


htm = HTMLrealt.new

message = ""
[:realdruzi].each do |el|
   htm.setProperty el
   htm.catchPage
   message = message + htm.msg + "\n"   
end
print message
#MailRealt.welcome("@gmail.com", htm.msg).deliver

