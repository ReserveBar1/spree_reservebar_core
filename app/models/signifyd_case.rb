class SignifydCase < ActiveRecord::Base
  belongs_to :order, class_name: 'Spree::Order'

  scope :open, -> { where(status: ['OPEN', 'PROCESSING', 'HELD', nil]) }
end
