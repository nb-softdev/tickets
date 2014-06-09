module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    if direction == "asc"
      title = image_tag("down_arrow.gif") + " " + title.to_s
    else  
      title = image_tag("up_arrow.gif") + " " + title.to_s
    end  
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), :class => direction, :remote => true
  end  
  
  def get_model_data(m, cemetery=false)
    if cemetery
      [["Select", ""]] + m.constantize.active.where(:cemetery_id => @cemetery.id).collect {|r| [r.name, r.id]}
    else
      [["Select", ""]] + m.constantize.active.collect {|r| [r.name, r.id]}
    end    
  end
  
  def get_users
    [["Select User", ""]] + User.all_users.collect {|r| [r.name, r.id]}
  end
  
  def get_company_users(company)
    [["Select User", ""]] + User.all_users_and_staffs.where(:company => company).collect {|r| [r.name, r.id]}
  end

  def get_company_staffs(company)
    [["Select Staff", ""]] + User.all_staffs.where(:company => company).collect {|r| [r.name, r.id]}
  end  
        
  
  def get_all_pages
    FooterPage.footer 
  end
  
  def get_ticket_status
    [["Open", "1"]] + [["On Hold", "2"]] + [["On Work", "3"]] + [["Close", "4"]] 
  end
  
  def ticket_status_hash
    {"1" => "Open", "2" => "On Hold", "3" => "On Work", "4" => "Close"}
  end
  
  def get_ticket_types
    [["Technical", "Technical"]] + [["General", "General"]] + [["Sell", "Sell"]]
  end

  def ticket_types_hash
    {"Technical" => "Technical", "General" => "General", "Sell" => "Sell"}
  end  
  
  def get_admin_and_company_admin_role
    [["SuperAdmin", "1"]] + [["CompanyAdmin", "2"]]
  end
  
  def get_staff_and_user_role
    [["Staff", "3"]] + [["User", "4"]]
  end
  
  def ticket_priority_hash
    {"1" => "Low", "2" => "Medium", "3" => "High", "4" => "Urgent", "5" => "Emergency", "6" => "Critical"}
  end  
  
  def get_ticket_priority
    [["Low", "1"]] + [["Medium", "2"]] + [["High", "3"]] + [["Urgent", "4"]] + [["Emergency", "5"]] + [["Critical", "6"]] 
  end
  
  def get_pager_numbers
    [["10", 10]] + [["20", 20]] + [["30", 30]] + [["40", 40]] + [["50", 50]]
  end
  
  def get_user_roles
    Role.all.collect {|r| [r.role_type, r.id]} 
  end
  
  def get_companies
    [["Select Company", ""]] + Company.all.collect {|c| [c.name, c.id]}
  end 
  
end
