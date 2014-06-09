class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
    
  belongs_to :user
  belongs_to :company

  validates_uniqueness_of :name, :if => :in_a_user?
  
  validates :name, :presence => true
  
  def in_a_user?
    user_in_tag_exist = Tag.find_by_name(name)
    if user_in_tag_exist
      user_id == user_in_tag_exist.user_id
    end  
  end
  
  include SearchHandler
end