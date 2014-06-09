class FooterPage < ActiveRecord::Base
  include SearchHandler
  validates :name, :page_route, :presence => true
  scope :footer, -> {where(:is_footer => true)}  
end
