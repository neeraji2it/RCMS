class Counselor::DashboardsController < ApplicationController
  before_filter :is_correct_user
  before_filter :is_login
  
  #counselor home page
  def home
    
  end

  #counselor appointments through calendar /counselor/dashboards/counselor_status?params[:date]&params[:day]
  def counselor_status
    @reminder = Reminder.new
    @reminders = current_user.reminders
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @start_date = @date.beginning_of_week(:sunday).to_date
    @end_date = @date.end_of_week(:sunday).to_date
    @day = params[:day].present? ? (Date.parse(params[:day])).to_date : Date.today
    @appointments = current_user.appointments.where("start_at BETWEEN '#{@day} 00:01:01' AND '#{@day} 23:59:59'")
    #    @appointments = current_user.appointments
    respond_to do |format|
      format.js
    end
  end

  #counselor appointments through calendar /counselor/dashboards/counselor_status?params[:date]&params[:day]
  def counselor_down_status
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @start_date = @date.beginning_of_week(:sunday).to_date
    @end_date = @date.end_of_week(:sunday).to_date
    @day = params[:day].present? ? Date.parse(params[:day]).to_date : Date.today
    @appointments = current_user.appointments.where("start_at BETWEEN '#{@day} 00:01:01' AND '#{@day} 23:59:59'")
    respond_to do |format|
      format.js
    end
  end
  
  #displaying the counselor appointments in calendar format
  def appointments
    @date = Date.today
    @start_date = @date.beginning_of_week(:sunday).to_date
    @end_date = @date.end_of_week(:sunday).to_date
    @rooms = Room.all
    @counselors = Counselor.all
    @cases = Case.all
    @counselor_room = CounselorAvailability.new
    @counselor_availabilities = CounselorAvailability.where("start_at BETWEEN '#{@start_date} 00:01:01' and '#{@end_date} 23:59:59'")
    @common_appointments = Array.new
    @main_appoints = Array.new
    @counselor_availabilities.each do |a|
      @common_appointments << a.start_at.strftime("%Y-%m-%d %H:%M:%S")+a.room_id.to_s
      @main_appoints << a
    end
  end
  
  
  #counselor cases /counselor/dashboards/case_list
  def case_list
    if params[:query] and params[:query] != "all"
      @cases = Case.where("status = '#{params[:query]}'")
      case_ids = @cases.map{|a| a.id}
      @appointments = current_user.appointments.where("case_id IN (#{case_ids.empty? ? '0' : case_ids.split(",").join(",")})")
    else
      @appointments = current_user.appointments
    end
  end
  
  def client_list
    @appointments = current_user.appointments
  end
  
end
