require 'spec_helper'

describe Spree::CheckoutController do
  let(:address) { Factory(:address) }
  let(:state) { Factory(:state) }
  let(:shipping_method) { Factory(:shipping_method) }
  let(:shipping_category) { Factory(:shipping_category, :name => 'Spirits') }
  let(:order) do
    Factory(:order)
  end
  let(:line_item) { Factory(:line_item, :order_id => order.id) }
  let(:payment_method) { Factory(:payment_method) }
  let!(:retailer) do
    Spree::Retailer.create(:name => 'Retailer1', :state => 'active',
                           :payment_method => payment_method,
                           :ships_spirits_to => address.state.abbr,
                           :email => 'retailer@test.com', :phone => '1234567890')
  end

  before do
    line_item.product.shipping_category = shipping_category
    order.line_items << line_item
    controller.stub :current_order => order, :current_user => Factory(:user)
    controller.stub :check_authorization
    Factory(:country)
  end


  context 'Retailer' do
    it 'Sets a retailer before the delivery step' do
      order.state = 'address'
      order.save!
      post :update, {id: order.to_param,
                     order: { bill_address_attributes: address_params ,
                              :ship_address_attributes => address_params },
                     state: 'delivery'
                    }
      order.state.should == 'delivery'
      order.retailer.should == retailer
    end
  end

  context "#edit" do

    it "should redirect to the cart path unless checkout_allowed?" do
      order.stub :checkout_allowed? => false
      get :edit, { :state => "delivery" }
      response.should redirect_to(spree.cart_path)
    end

    it "should redirect to the cart path if current_order is nil" do
      controller.stub(:current_order).and_return(nil)
      get :edit, { :state => "delivery" }
      response.should redirect_to(spree.cart_path)
    end

    it "should redirect to cart if order is completed" do
      order.stub(:completed? => true)
      get :edit, {:state => "address"}
      response.should redirect_to(spree.cart_path)
    end

  end

  context "#update" do

    context "save successful" do

      it "should assign order" do
        order.stub :state => "address"
        post :update, {:state => "confirm"}
        assigns[:order].should_not be_nil
      end

      context "with next state" do

        it "should advance the state" do
          order.state = "address"
          post :update, {:state => "delivery"}
          order.state.should == 'delivery'
        end

        it 'should skip the confirm step' do
          order.stub :state => "payment"
          order.should_receive(:next).and_return true
          post :update, {:state => "complete"}
        end
      end
    end

    context "save unsuccessful" do
      before { order.should_receive(:update_attributes).and_return false }

      it "should assign order" do
        post :update, {:state => "confirm"}
        assigns[:order].should_not be_nil
      end

      it "should not change the order state" do
        order.should_not_receive(:update_attribute)
        post :update, { :state => 'confirm' }
      end
    end

    context "when current_order is nil" do
      before { controller.stub :current_order => nil }
      it "should not change the state if order is completed" do
        order.should_not_receive(:update_attribute)
        post :update, {:state => "confirm"}
      end

      it "should redirect to the cart_path" do
        post :update, {:state => "confirm"}
        response.should redirect_to spree.cart_path
      end
    end
  end

  context "When last inventory item has been purchased" do
    let(:product) { mock_model(Spree::Product, :name => "Amazing Object") }
    let(:variant) { mock_model(Spree::Variant, :on_hand => 0) }
    let(:line_item) { mock_model Spree::LineItem, :insufficient_stock? => true }
    let(:order) { Factory(:order) }

    before do
      order.stub(:line_items => [line_item])

      reset_spree_preferences do |config|
        config.track_inventory_levels = true
        config.allow_backorders = false
      end

    end

    context "and back orders == false" do
      before do
        post :update, {:state => "payment"}
      end

      it "should render edit template" do
        response.should redirect_to spree.cart_path
      end

      it "should set flash message for no inventory" do
        flash[:error].should == I18n.t(:spree_inventory_error_flash_for_insufficient_quantity , :names => "'#{product.name}'" )
      end

    end

  end

  def address_params
    { firstname: address.firstname,
      lastname: address.lastname,
      address1: address.address1,
      city: address.city,
      zipcode: address.zipcode,
      phone: address.phone,
      state_id: address.state.id }
  end

end
