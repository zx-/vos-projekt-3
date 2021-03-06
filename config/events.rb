WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.

  # websockets

  namespace :websocket_rails do
    subscribe :subscribe_private, :to => ChatSocketController, :with_method => :authorize_channels
  end

  namespace :room do
    subscribe :web_resource_highlight, :to => ChatSocketController, :with_method => :web_resource_highlight
    subscribe :list_all_resources, :to => ChatSocketController, :with_method => :list_all_resources
    subscribe :submit_message, :to => ChatSocketController, :with_method => :submit_message
    subscribe :add_web_resource, :to => ChatSocketController, :with_method => :add_web_resource
    subscribe :remove_web_resource, :to => ChatSocketController, :with_method => :remove_web_resource
    subscribe :note_msg, :to => ChatSocketController, :with_method => :note_msg
    subscribe :list_all_notes, :to => ChatSocketController, :with_method => :list_all_notes
  end

end
