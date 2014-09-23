module CafePress
  module SimpleOrderAPI
    class Client
      attr_accessor :partner_id

      def initialize(partner_id)
        @partner_id = partner_id
      end

      def create_order(order_id, shipping_address, line_items, options = {})
        Client::OrderRequest.create_order(order_id, shipping_address, line_items, options)
      end

      def get_order_status(order_id)

      end

      def get_shipping_info(order_ids, options = {})

      end

    end # end for class Client
  end # end for module EZP
end # end for  module CafePress