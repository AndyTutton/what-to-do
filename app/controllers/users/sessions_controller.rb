# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @group = Group.find_by_invite_token(params[:invite_token]) if params[:invite_token]
    super
  end

  # POST /resource/sign_in
  def create
    group = Group.find_by_invite_token(params[:user][:invite_token])
    Membership.where(group: group, user: current_user).first_or_create if group
    super
    if group
      set_flash_message! :notice, :joined_group, group: group.name
    end
  end

  def show
    @groups = Group.where(user: current_user)
    @saves = Save.where(user: current_user).last(5)
    user_groups = current_user.groups

    @bookings = user_groups.map { |group| group.events.where(booked: true) }.flatten
    @bookings_attending = user_groups.map { |group| group.events.where(booked:true) }.flatten
    @bookings_pending = user_groups.map { |group| group.events.where(booked:true) }.flatten
    @bookings_past = user_groups.map { |group| group.events.where(booked:true) }.flatten


  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
