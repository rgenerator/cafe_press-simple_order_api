require 'cafe_press/simple_order_api'
module CafePress
  module SimpleOrderAPI
    class Client
      attr_accessor :partner_id, :savon_client

      # We want camelcase translation for 98% of keys. The other
      # 2% result in the incorrect names so we translate them ourselves.
      # Saxon will not translate string keys.
      @@key_conversions = {
        :product_id      => 'ProductID',
        :country_code    => 'CountryCodeISO',
        :billing_address => 'OptionalBillingAddressOverride'
      }

      def initialize(partner_id, options = {})
        @partner_id = partner_id

        options = options.dup
        if options.delete(:debug)
          options.merge!(log: true, log_level: :debug, pretty_print_xml: true)
        end

        @savon_client = Savon.client(wsdl: end_point(options), convert_request_keys_to: :camelcase)
      end

      def create_order(order_hash)
        # customer, order, order_items
        @savon_client.call(:create_order, message: include_partner_id(order_hash))
      end

      def get_order_by_secondary_identifier(identification_hash)
        @savon_client.call(:get_order_by_secondary_identifier, message: identification_hash)
      end

      def cancel_order(cafe_press_order_id)
        hash = {:SalesOrderNo => cafe_press_order_id, :PartnerID => @partner_id }
        @savon_client.call(:cancel_cp_sales_order, message: hash)
      end

      def get_order_status(cafe_press_order_id)
        hash = {:OrderNo => cafe_press_order_id, :PartnerID => @partner_id }
        puts client.call(:get_cp_sales_order_status,:message=> hash)
      end

      def get_shipping_info(cafe_press_order_id)
        hash = {:SalesOrderNo => cafe_press_order_id, :PartnerID => @partner_id }
        @savon_client.call(:cancel_cp_sales_order, message: hash)
      end

      private
      def translate_hash(hash)
      end

      def end_point(options = {})
        if options[:live]
          CafePress::SimpleOrderAPI::LIVE_ENDPOINT
        else
          CafePress::SimpleOrderAPI::TEST_ENDPOINT
        end
      end

      def include_partner_id(hash ={})
        unless hash.has_key?(:PartnerID)
          hash[:PartnerID] = @partner_id
        end
      end

    end # end for class Client
  end # end for module EZP
end # end for  module CafePress
