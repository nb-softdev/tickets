class Tagging < ActiveRecord::Base
  belongs_to :tag
  
  include SearchHandler
end