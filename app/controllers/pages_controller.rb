class PagesController < ApplicationController

  def index
  	logger.info "Current User: #{current_user.inspect}"
  end

end
