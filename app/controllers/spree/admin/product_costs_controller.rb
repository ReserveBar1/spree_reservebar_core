module Spree
  module Admin
    class ProductCostsController < ResourceController
      before_filter :load_data #, :only => [:edit, :new, :update, :create]


      # GET /retailer/1/product_costs
      # GET /retailer/1/product_costs.json
      # Get a list of all products, so we show all variants and cost for the retailer, even if the retailer's cost is not yet set
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
       end


     # PUT /product_costs/1
     # PUT /product_costs/1.json
      def update
        @product_cost = ProductCost.find(params[:id])

        respond_to do |format|
          if @product_cost.update_attributes(params[:spree_product_cost])
             format.json { head :ok }
          else
            format.json { render json: @product_cost.errors, status: :unprocessable_entity }
          end
        end
      end

      def import
        if params[:file].blank?
          flash.notice = "Please select a file to upload"
        else
          Spree::ProductCost.import(params[:file].tempfile)
          flash.notice = "Your Retailer Costs have been updated"
        end

        redirect_to admin_retailer_product_costs_path(params[:retailer_id])
      end

    	protected

      def collection
        return @collection if @collection.present?

        unless request.xhr?
          params[:search] ||= {}

          params[:search][:meta_sort] ||= "name.asc"
          @search = Spree::Product.not_deleted.metasearch(params[:search])

          @collection = @search.relation.group_by_products_id.includes([:master, {:variants => [:images, :option_values]}]).page(params[:page]).per(Spree::Config[:admin_products_per_page])
        else
          includes = [{:variants => [:images,  {:option_values => :option_type}]}, :master, :images]

          @collection = Spree::Product.not_deleted.where(["name #{LIKE} ?", "%#{params[:q]}%"])
          @collection = @collection.includes(includes).limit(params[:limit] || 10)

          tmp = Spree::Product.not_deleted.where(["#{Variant.table_name}.sku #{LIKE} ?", "%#{params[:q]}%"])
          tmp = tmp.includes(:variants_including_master).limit(params[:limit] || 10)
          @collection.concat(tmp)

          @collection.uniq
        end
      end

      private

      # Load up retailer
    	def load_data
    	  @retailer = Retailer.find(params[:retailer_id])
      end

    end
  end
end
