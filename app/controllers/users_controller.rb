class UsersController < ApplicationController

  skip_before_filter :require_authentication, :only => [:new, :create]
  skip_before_filter :require_admin_authentication, :only => [:new, :create, :edit, :update]

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        if !params[:seat_id].nil?
          @seat = Seat.find(params[:seat_id]) #if a seat param comes in (i.e. page was rendered from a non-logged-in user that wanted to sign up)
          @seat.update_attribute(:user_id => @user.id) #add user id to seat object
        end
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end
end
