module Spree
  class CompanyCost < ActiveRecord::Base

    validates_presence_of     :name
    validates_uniqueness_of   :name

    validate                  :value_and_percentage_are_not_both_present
    validate                  :value_or_percentage_is_present

    validates_numericality_of :value,      :allow_nil => true,
                                           :less_than_or_equal_to => 999999.99,
                                           :greater_than_or_equal_to => 0.0

    validates_numericality_of :percentage, :allow_nil => true,
                                           :less_than_or_equal_to => 100.0,
                                           :greater_than_or_equal_to => 0.0

    private

    def value_and_percentage_are_not_both_present
      if value && percentage
        errors.add(:value,      " - the 'dollar value' can't be set if a 'percentage' is set")
        errors.add(:percentage, " - the 'percentage' can't be set if a 'dollar value' is set")
      end
    end

    def value_or_percentage_is_present
      if value.blank? && percentage.blank?
        errors.add(:value,      " - you must set a 'dollar value' or 'percentage'")
        errors.add(:percentage, " - you must set a 'dollar value' or 'percentage'")
      end
    end

  end
end
