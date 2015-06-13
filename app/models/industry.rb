class Industry < ActiveRecord::Base
  has_many  :clients

  def name
    "#{code}||#{title}"
  end
end
