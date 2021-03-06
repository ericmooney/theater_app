class UsersController < ApplicationController

 skip_before_filter :require_authentication, :only => [:new, :create]
 skip_before_filter :require_admin_authentication, :only => [:new, :create, :edit, :update, :show]


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
          @seat.update_attributes(:user_id => @user.id) #add user id to seat object
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
    @user = User.find(session[:user_id])
    @seats = Seat.where(:user_id => [@user.id])

    @seats_array = @seats.sort{
      |a,b| (a.showtime.date == b.showtime.date) ? a.showtime.movie.name <=> b.showtime.movie.name : a.showtime.date <=> b.showtime.date
    }

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])

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
