module Slugable
  #extend Active Record Base Class via Active Support Concern to be able to share Module code in all models
  extend ActiveSupport::Concern
  
  included do
    #create slug before record is saved to database
    before_save :generate_slug!
    #make sure slug_column can be called on subclasses
    class_attribute :slug_column
  end

  #create slug from regex method and module ClassMethods below (with method slugable_column, which is called from respective model)
  def generate_slug!
    str = to_slug(self.send(self.class.slug_column.to_sym))
    #handle special case with doubled records 
    unless str == nil
      count = 2
      obj = self.class.where(slug: str).first
      while obj && obj != self
        str = str + "-" + count.to_s
        obj = self.class.where(slug: str).first
        count += 1
      end
      #make sure to only have downcase slugs
      self.slug = str.downcase
    end
  end

  #regex method
  def to_slug(name)
    if name != nil
    #strip the string
    ret = name.strip
    
    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric with dash
     ret.gsub! /\s*[^A-Za-z0-9]\s*/, '-'

     #convert double dashes to single
     ret.gsub! /-+/,"-"

     #strip off leading/trailing dash
     ret.gsub! /\A[-\.]+|[-\.]+\z/,""

     ret
     end
  end

  #construct an URL path from slug string
  def to_param
    self.slug
  end

  module ClassMethods
    def slugable_column(col_name)
      self.slug_column = col_name
    end
  end

end