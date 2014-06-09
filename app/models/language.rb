class Language < ActiveRecord::Base
  include SearchHandler
  validates :name, :code, :presence => true
end
