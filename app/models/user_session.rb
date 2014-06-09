class UserSession < Authlogic::Session::Base

  remember_me_for 1.year
  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  def persisted?
    false
  end

end
