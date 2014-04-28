class ChatSocketController < WebsocketRails::BaseController

  before_filter :authenticate_user!

  def initialize_session

    # chat socket setup

  end



end