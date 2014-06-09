module SearchHandler
  extend ActiveSupport::Concern

  included do
    
    def self.search(search)
      if search
        search_keys = ''
        search.each do |k, v|
          unless v.blank?
            if k == "status_id" or k == "priority_id"
              search_keys = "#{search_keys} #{k} = #{v} AND"
            else  
              search_keys = "#{search_keys} #{k} LIKE '%#{v}%' AND"
            end
          end  
        end
        
        search_keys.strip!
        3.times do search_keys.chop! end
       
        if search_keys
          where(search_keys)
        end
      else
        scoped
      end
    end
    
    
    def self.user_search(search)
      if search
        search_keys = ''
        search.each do |k, v|
          unless v.blank?
            if k == "company_id"
              search_keys = "#{search_keys} #{k} = #{v} AND"
            else  
              search_keys = "#{search_keys} #{k} LIKE '%#{v}%' AND"
            end  
          end
        end
        
        search_keys.strip!
        3.times do search_keys.chop! end
       
        if search_keys
          where(search_keys)
        end
      else
        scoped
      end
    end    
    
    
  end
  
    
  
end