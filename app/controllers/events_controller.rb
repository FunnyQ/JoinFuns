class EventsController < ApplicationController
  layout :setting_layout
  impressionist :actions=>[:show]
  before_action :authenticate_user!, except: [:index]

  def index

    set_events
    events_order

    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      #address=Geocoder.coordinates(event.address)
      marker.lat event.latitude
      marker.lng event.longitude
      marker.json({ :id => event.id })
      marker.picture({
        :url => view_context.image_path("#{event.category}-icon@2x.png"),
        :width   => 43,
        :height  => 51,
        :marker_anchor => [30, true]
      })
    end

  end

  def show
    @event = Event.find(params[:id])
    gon.showtime = @event.showtime.to_i

    @event.event_show_process(params[:uid]) if @event.budget

    @events = Event.includes(:prices, :user).order('impressions_count DESC ').limit(10)

    @comment = Comment.new
    @comments = @event.comments.order("created_at desc")



  end

  def new
    @event= Event.new

    #8.times{ @event.photos.build }
    3.times{ @event.prices.build }
  end

  def create
    @event= Event.new(event_params)
    @event.user = current_user
    budget = params[:event][:budget]


    if budget && budget!=""
      @event.category_cd = 1
    else
      @event.category_cd = 0
    end

    #category = view_context.te(@event, :category)

    if @event.save
      flash[:success] = "已成功建立！"
      redirect_to events_path(latitude:@event.latitude,longitude:@event.longitude)
    else
      flash[:error] = "請檢查欄位後再試一次。"
      render :new
    end
  end

  def collect

    @event = Event.find(params[:id])

    collect = @event.is_collected?(current_user)

    if collect
      current_user.collects.find_by(:event_id => @event.id).destroy
    else
      current_user.collects.create!( :event => @event )
    end

    respond_to do |format|
     format.html {
       redirect_to event_path(@event)
     }
     format.js
    end


  end

  def get_balance

    @balance = current_user.money

    respond_to do |format|

      format.js

    end

  end

  # def search
  #   @events = @events.where("address like ?", params[:address]) unless address.blank?
  #   @events = @events.where("title like ?", params[:keyword]) unless keyword.blank?
  #   @events
  # end

  private

  def event_params
    params.require(:event).permit(:title, :category, :contact_phone, :email, :website, :organizer, :price, :event_type, :description, :address, :hoster, :start_time, :end_time, :cover, :budget, :showtime, prices_attributes:[:price])
  end

  def setting_layout
    case action_name
    when 'index'
      'map_view'
    else
      'application'
    end
  end

  def set_events
    address = params[:address]
    keyword = params[:keyword]
    combine_keyword = params[:combine_keyword]
    time = params[:time]
    distance = params[:distance]
    price = params[:price]
    latitude = cookies[:lat]
    longitude = cookies[:lng]

    return @events = Event.includes(:prices).search(combine_keyword: combine_keyword, time: time, keyword: keyword, address: address, distance: distance, latitude: latitude, longitude: longitude, price: price) if params[:search]
    @events = Event.includes(:prices).where(['end_time > ?' , Date.today]).limit(100)
  end

  def events_order

    if params[:order]

      sort_by = case params[:order]
        when 'hottest'
          'impressions_count DESC '
        when 'newest'
          'created_at DESC'
      end

      @events = @events.order(sort_by)
    else
      @events = @events.order("events.id desc")
    end

  end



end
