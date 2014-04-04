module Spree
  module Admin
    class BrandsController < ResourceController

      def index
        @brand_owners = Spree::BrandOwner.all
      end

    end
  end
end
