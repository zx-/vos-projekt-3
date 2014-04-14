class ChatController < ApplicationController

  before_filter :authenticate_user!

  def index

    @room=params[:room];

  end

end
