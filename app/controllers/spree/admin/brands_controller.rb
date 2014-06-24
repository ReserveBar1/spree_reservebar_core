module Spree
  module Admin
    class BrandsController < ResourceController

      def index
        @brand_owners = Spree::BrandOwner.all
      end

      def new
        @brand_owners = Spree::BrandOwner.all
        @brand = Spree::Brand.new
        @brand_owner_keys = @brand_owners.map do |owner|
          [owner.title, owner.id]
        end
      end

      def create
        @brand = Spree::Brand.new(params[:brand])
        if @brand.save
          flash.notice = :successfully_created
          redirect_to admin_brands_path
        end
      end

      def edit
        @brand_owners = Spree::BrandOwner.all
        @brand = Spree::Brand.find(params[:id])
        @brand_owner_keys = @brand_owners.map do |owner|
          [owner.title, owner.id]
        end
      end

    end
  end
end
