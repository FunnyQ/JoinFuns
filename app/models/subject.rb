class Subject < ActiveRecord::Base
  belongs_to :user
  has_attached_file :cover, :styles => { :medium => "600x600>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  validate :enough_money, if: Proc.new { |a| a.budget.present? }, :on => :create
  def enough_money

    user = User.find_by_id(user_id)
    if budget > user.money
      errors.add(:budget, "can't greater than your money")
    else
      new_money = user.money - budget
      User.update(user.id,:money=>new_money)
    end

  end
end
