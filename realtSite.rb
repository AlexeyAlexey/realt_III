#!ruby --encoding=cp1251
#coding: UTF-8

require 'open-uri' 
require 'fileutils'
require 'active_record'
require 'action_mailer'
require 'yaml'

Dir.chdir(File.dirname File.expand_path('../realtSite.rb', __FILE__))

ActiveRecord::Base.establish_connection YAML.load_file('db.yaml')
  
class RealtSecond < ActiveRecord::Base
end

ActionMailer::Base.smtp_settings = YAML.load_file('mailer.yaml')

class MaileRealt < ActionMailer::Base
 self.default :from => "ialexey.kondratenko@gmail.com", :charset => "Windows-1251"
 
 def welcom(recipient, msg)

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
      print  DBSites, "\n\n"   
      @msg = ""
      @site = DBSites[site]
      #print  site["parameters"].class, "\n\n"
      siteP = ""
      @site["parameters"].each_pair{|key, value| siteP = siteP + key.to_s + "=#{value}&"}
      @urlSite = @site["scheme"] + "://" + @site["hostName"] + "/" + @site["resourcePath"] + "?" + siteP
     
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
                  if !RealtSecond.where(:value_id => res[3]).exists?
                    then 
                        RealtSecond.create(:reference => res[0], :value_id => res[3])                        
                        @msg = @msg + " - " + res[0].clone + "\n"                                      
                  end                  
            end

         end#str_html      
      (@msg = @msg + "Nothing") if @msg == ""      
   end

end

htm = HTMLrealt.new(:realt)

htm.catchPage
print htm.msg
#MaileRealt.welcom("@gmail.com", htm.msg).deliver

