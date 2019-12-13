class ApplicationController < ActionController::Base
  def root
    render :plain => "I'm awesome"
  end
end
