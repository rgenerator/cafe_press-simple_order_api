module CafePress
  module SimpleOrderAPI
    class Client
      attr_accessor :partner_id


      def initialize(partner_id)
        @partner_id = partner_id
      end

      def fulfill(order_id, shipping_address, line_items, options = {})

      end

      def check_order_status(order_id)
      end

      def fetch_tracking_data(order_ids, options = {})

      end

    end # end for class Client
  end # end for module EZP
end # end for  module CafePress