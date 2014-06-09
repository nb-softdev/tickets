class Setting < ActiveRecord::Base
  
  validates :default_name, :default_label, :presence => true
  
  #scope :current_week, -> { where(:default_label => 'current_week') }

  include SearchHandler  
end
