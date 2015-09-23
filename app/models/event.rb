class Event < ActiveRecord::Base

  has_many :comments
  has_many :prices
  has_many :collects
  belongs_to :user
  has_many :user_collects, :through => :collects, :source => :user
  accepts_nested_attributes_for :prices

  as_enum :category, event: 0, dm: 1


  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  is_impressionable :counter_cache => true, :unique => true

  has_attached_file :cover, :styles => { :medium => "600x600>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
  validates_numericality_of :budget
  validates_presence_of :title, :cover, :address, :contact_phone, :start_time, :end_time, :description, :showtime, :budget
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

  def is_collected?(user)

    user.collects.exists?(event_id: self.id)

  end

  def event_show_process(user)
    if user
      self.budget -= 1.5
      self.save
      u = User.find_by_id(user)
      u.money += 0.5
      u.save
    else
      self.budget -=1
      self.save
    end
  end

  def self.search(args)
    address = args[:address]
    keyword = args[:keyword]
    combine_keyword = args[:combine_keyword]
    time_code = args[:time].to_i
    latitude = args[:latitude]
    longitude = args[:longitude]
    distance = args[:distance]
    price = args[:price].to_i



    # where(:title, query) -> This would return an exact match of the query
    filtered_events = Event.joins(:prices)

    #where("address like ?", "%#{address}%") unless address.blank?
    filtered_events = filtered_events.where("address like ? or title like ?", "%#{combine_keyword}%", "%#{combine_keyword}%" ) if combine_keyword.present?
    filtered_events = filtered_events.where("address like ?", "%#{address}%" ) if address.present?
    filtered_events = filtered_events.where("title like ?", "%#{keyword}%") if keyword.present?
    filtered_events = filter_by_time(code: time_code, collection: filtered_events) if time_code.present?
    filtered_events = filtered_events.near([latitude,longitude],distance, :units=>:km) if distance.present?
    #filtered_events = filtered_events.where("prices.price = 0").distinct if price.present?
    filtered_events = filter_by_price(code: price, collection: filtered_events) if price.present?
    filtered_events
  end



  private

   def self.filter_by_price(args)
    code = args[:code]
    collection = args[:collection]

    case code
      when 0
        collection.where("prices.price = 0").distinct
      when 1
        collection.where("prices.price < 300").distinct
      when 2
        collection.where("prices.price > 300").distinct
    end

  end

  def self.filter_by_time(args)
    code = args[:code]
    collection = args[:collection]
    current_time = Time.zone.now

    case code
      when 0
        collection.between_times(current_time - 1.weeks, current_time)
      when 1
        collection.between_times(current_time - 2.weeks, current_time)
      when 2
        collection.between_times(current_time - 4.weeks, current_time)
      when 3
        collection.between_times(current_time - 24.weeks, current_time)
    end
  end


end
