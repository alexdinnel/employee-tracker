class Project < ActiveRecord::Base

  belongs_to :employee

  def self.not_done
    where({:done => false})
  end

  def self.done
    where({:done => true})
  end

end
