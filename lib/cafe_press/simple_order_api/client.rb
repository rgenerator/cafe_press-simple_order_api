require 'cafe_press/simple_order_api'
require 'cafe_press/simple_order_api/client/order_request'
require 'cafe_press/simple_order_api/client/shipping_request'

module CafePress
  module SimpleOrderAPI
    class Client
      attr_accessor :partner_id

      def initialize(partner_id)
        @partner_id = partner_id
      end

      def create_order(order_hash, options = {})
        Client::OrderRequest.new(@partner_id).create_order(order_hash, options)
      end

      def get_order_status(order_id)
        Client::OrderRequest.get_status(order_id, shipping_address, line_items, options)
      end

      def cancel_order(order_id)
        Client::OrderRequest.cancel_order(order_id)
      end

      def get_shipping_info(order_ids, options = {})
        Client::ShipmentRequest.get_shipping_info(order_ids, options = {})
      end

    end # end for class Client
  end # end for module EZP
end # end for  module CafePress