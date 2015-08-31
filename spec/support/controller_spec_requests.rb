require 'active_support/all'
module ControllerSpecRequests
  def get(action, params={}, session=nil, flash=nil)
    process_spree_action(action, params, session, flash, "GET")
  end

  def post(action, params={}, session=nil, flash=nil)
    process_spree_action(action, params, session, flash, "POST")
  end

  def put(action, params={}, session=nil, flash=nil)
    process_spree_action(action, params, session, flash, "PUT")
  end

  def delete(action, params={}, session=nil, flash=nil)
    process_spree_action(action, params, session, flash, "DELETE")
  end

  def process_spree_action(action, params={}, session=nil, flash=nil, method="get")
    scoping = respond_to?(:resource_scoping) ? resource_scoping : {}
    process(action, params.merge(scoping).reverse_merge!(:use_route => :spree), session, flash, method)
  end
end

RSpec.configure do |config|
  config.include ControllerSpecRequests, :type => :controller
end
