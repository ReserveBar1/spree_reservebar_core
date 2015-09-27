require 'spec_helper'

describe Spree::CheckoutController do
  let(:address) { Factory(:address) }
  let(:state) { Factory(:state) }
  let(:shipping_method) { Factory(:shipping_method) }

  let(:shipping_category) { Factory(:shipping_category, name: 'Spirits') }
  let(:order) do
    Factory(:order)
  end
  let(:line_item) { Factory(:line_item, order_id: order.id) }
  let(:payment_method) { Factory(:payment_method) }
  let!(:retailer) do
    Spree::Retailer.create(name: 'Retailer1', state: 'active',
                           payment_method: payment_method,
                           ships_spirits_to: address.state.abbr,
                           email: 'retailer@test.com', phone: '1234567890')
  end

  before do
    line_item.product.shipping_category = shipping_category
    order.line_items << line_item
    controller.stub current_order: order, current_user: Factory(:user)
    controller.stub :check_authorization
    Factory(:country)
  end

  context 'Retailer' do
    it 'Sets a retailer before the delivery step' do
      order.ship_address = address
      order.state = 'delivery'
      order.save!
      post :update, id: order.to_param,
                    order: { shipping_method_id: shipping_method.id }

      order.state.should eq 'payment'
      order.retailer.should eq retailer
    end

    it 'Sets flash if any item has order address in states_blacklist' do
      order.ship_address = address
      order.state = 'delivery'
      order.save!
      order.products.first.stub(state_blacklist: address.state.abbr)
      post :update, id: order.to_param,
                    order: { shipping_method_id: shipping_method.id }

      flash.notice.should eq I18n.t('exception.product_not_deliverable')
    end
  end

  context '#edit' do
    it 'should redirect to the cart path unless checkout_allowed?' do
      order.stub checkout_allowed?: false
      get :edit, state: 'delivery'
      response.should redirect_to(spree.cart_path)
    end

    it 'should redirect to the cart path if current_order is nil' do
      controller.stub(:current_order).and_return(nil)
      get :edit, state: 'delivery'
      response.should redirect_to(spree.cart_path)
    end

    it 'should redirect to cart if order is completed' do
      order.stub(completed?: true)
      get :edit, state: 'address'
      response.should redirect_to(spree.cart_path)
    end
  end

  context '#update' do
    context 'save successful' do
      it 'should assign order' do
        order.stub state: 'address'
        post :update, state: 'confirm'
        assigns[:order].should_not be_nil
      end
    end

    context 'save unsuccessful' do
      before { order.should_receive(:update_attributes).and_return false }

      it 'should assign order' do
        post :update, state: 'confirm'
        assigns[:order].should_not be_nil
      end

      it 'should not change the order state' do
        order.should_not_receive(:update_attribute)
        post :update, state: 'confirm'
      end
    end

    context 'when current_order is nil' do
      before { controller.stub current_order: nil }
      it 'should not change the state if order is completed' do
        order.should_not_receive(:update_attribute)
        post :update, state: 'confirm'
      end

      it 'should redirect to the cart_path' do
        post :update, state: 'confirm'
        response.should redirect_to spree.cart_path
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
      state_id: address.state.id,
      country_id: address.country.id
    }
  end
end
