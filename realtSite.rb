#!ruby --encoding=cp1251
#coding: UTF-8

require 'open-uri' 
require 'fileutils'
require 'active_record'
require 'action_mailer'
require 'yaml'

Dir.chdir(File.dirname File.expand_path('../realtSite.rb', __FILE__))

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

DBSites = YAML.load_file('dbSites.yaml')

attr_reader :msg

private 
  
   def initialize(site)         
      @msg = ""
      @site = DBSites[site]      
      siteP = ""
      @site["parameters"].each_pair{|key, value| siteP = siteP + key.to_s + "=#{value}&"}
      @headSite = @site["scheme"] + "://" + @site["hostName"] + "/" 
      @urlSite = @headSite + @site["resourcePath"] + "?" + siteP
   end
   
   def str_html 
      uri = URI.parse @urlSite
      uri.read      
   end
   
  
public

   def catchPage
       
         str_html.each_line do |str|
            res = @site["regexpr"].match str
            
            if res
              then                  
                  if !RealtThird.where(:value_id => res[2], :host_name => @site["hostName"]).exists?
                    then 
                        source = @headSite + @site["resourcePath2"] + "?" + @site["id"] + "=#{res[2]}"
                        RealtThird.create(:reference => source, 
                                          :value_id => res[2],
                                          :valute => "dolars",
                                          :host_name => @site["hostName"])                        
                        @msg = @msg + " - " + source + "\n"                                      
                  end                  
            end

         end#str_html      
      (@msg = @msg + "Nothing") if @msg == ""      
   end

end

htm = HTMLrealt.new(:blagovist)

htm.catchPage
print htm.msg
#MailRealt.welcome("@gmail.com", htm.msg).deliver

