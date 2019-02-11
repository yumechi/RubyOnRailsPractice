module SessionsHelper

  # login user
  def log_in(user)
    session[:user_id] = user.id
  end

  # do eternal user session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  # return current user(if user is not found, return nil)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # check current user login
  def logged_in?
    !current_user.nil?
  end

  # collapse user session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logout user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # redirect to stored url or default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # store url to try to access
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
