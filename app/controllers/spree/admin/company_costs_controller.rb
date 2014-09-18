module Spree
  module Admin
    class CompanyCostsController < ResourceController

      def index
        @company_costs = Spree::CompanyCost.all
      end

      def new
        @company_cost = Spree::CompanyCost.new
      end

      def create
        @company_cost = Spree::CompanyCost.new(params[:company_cost])
        if @company_cost.save
          flash.notice = :successfully_created
          redirect_to admin_company_costs_path
        else
          render :new
        end
      end

      def edit
        @company_cost = Spree::CompanyCost.find(params[:id])
      end

    end
  end
end
