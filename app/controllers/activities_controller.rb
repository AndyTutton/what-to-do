class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all.filter do |activity|
      current_user.saves.where(activity_id: activity.id).length == 0
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def share
    @activity = Activity.find(params[:id])
    @groups = Group.where(user: current_user)
  end
end
