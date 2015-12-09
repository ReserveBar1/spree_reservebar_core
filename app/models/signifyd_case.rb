class SignifydCase < ActiveRecord::Base
  belongs_to :order, class_name: 'Spree::Order'
end
