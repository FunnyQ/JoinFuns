class HostsController < ApplicationController
  layout 'hosts'

  def show

    @host = User.find_by_id(params[:id])
    @host_image = @host.photos
    @in_progress_events = @host.events.where("end_time >= ?",Time.now)
    @overdue_events = @host.events.where("end_time < ?",Time.now)
    @in_progress_subjects = @host.subjects.where("end_time >= ?",Time.now)
    @overdue_subjects = @host.subjects.where("end_time < ?",Time.now)
    @events = Event.all


  end

  def update

    if current_user.update(get_params)
      redirect_to host_path(current_user)
      flash[:notice] = "更新成功"
    else
      render :action => :show
    end

  end



  private

  def get_params
    params.require(:user).permit(:name, :website, :cell_phone, :email, :address, :description, photos_attributes:[:pic])
  end

end
