require 'cafe_press/simple_order_api'
module CafePress
  module SimpleOrderAPI
    class Client
      attr_accessor :partner_id,:savon_client

      def initialize(partner_id, options = {})
        @partner_id = partner_id
        @savon_client = Savon.client(wsdl: end_point(options),
                                log_level: :debug,
                                log: true,
                                convert_request_keys_to: :camelcase,
                                pretty_print_xml: true,
                                namespaces: {
                                   'xmlns:caf' => "http://Cafepress.com/"
                                  },
                               )
      end

      def create_order(order_hash)
        @savon_client.call(:create_order, order_hash)
      end

      def get_order_status(order_id)
        @savon_client.call(:create_order, order_hash)
      end

      def cancel_order(order_id)
        Client::OrderRequest.cancel_order(order_id)
      end

      def get_shipping_info(order_ids, options = {})
        Client::ShipmentRequest.get_shipping_info(order_ids, options = {})
      end

      private
      def end_point
          if @options[:live]
            CafePress::SimpleOrderAPI::LIVE_ENDPOINT
          else
            CafePress::SimpleOrderAPI::TEST_ENDPOINT
          end
        end

    end # end for class Client
  end # end for module EZP
end # end for  module CafePress