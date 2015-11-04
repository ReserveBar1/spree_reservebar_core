module Exceptions
  # Raise if there is no retailer that can ship alcoholic products to the state selected
  class NoRetailerShipsToStateError < RuntimeError; end
  
  # Raise if there is no retailer that can ship alcoholic products to the county selected
  class NoRetailerShipsToCountyError < RuntimeError; end

  # Raise if the retailer selector cannot find a retailer that can ship the entire order
  class NoRetailerCanShipFullOrderError < RuntimeError; end
  
  # Raise if there the order can only be partially shipped to the desired state
  class PartialShippingPossibleError < RuntimeError; end
  
  # Raise if none of th selectd items can be shipped, but items in other categories can be shipped to the state
  class CanShipOtherItemsOnlyError < RuntimeError; end
  
  # Raise if the legal drinking age flag has not been set.
  class NotLegalDrinkingAgeError < RuntimeError; end
  
  # Raise when the user is trying to add bottles that would push it over the limit
  class BottleLimitPerOrderExceededError < RuntimeError; end
  class ArdbegBottleLimitPerOrderExceededError < RuntimeError; end
  
  # Raise when the user tries to add a new billing address that his invalid
  class NewBillAddressError < RuntimeError; end
  
end