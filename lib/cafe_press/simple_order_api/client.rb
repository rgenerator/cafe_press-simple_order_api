require 'savon'

module CafePress
  module SimpleOrderAPI
    Error = Class.new(StandardError)
    ConnectionError = Class.new(Error)
    InvalidRequestError = Class.new(Error)

    class Client
      def initialize(partner_id, options = {})
        @partner_id = partner_id
        raise ArgumentError, 'partner_id is required' unless @partner_id

        options = options.dup
        options[:wsdl] = endpoint(options.delete(:test))
        options[:convert_request_keys_to] = :none

        if options.delete(:debug)
          options.merge!(log: true, log_level: :debug, pretty_print_xml: true)
        end

        @savon_client = Savon.client(options)
      end

      def create_order(order_id, shipping_address, line_items, options = {})
        @order = options[:order]
        @line_items = line_items
        @shipping_address = shipping_address
        response = send_request(:create_order, build_order_hash)
        response[:create_order_response][:create_order_result]
      end

      def get_order_by_secondary_identifier(identification_code, order_id, options = {})
        hash = { IdentifierCode: identification_code, PartnerID: @partner_id, Identifier: order_id }
        response = send_request(:get_order_by_secondary_identifier, hash)
        response[:get_order_by_secondary_identifier_response][:get_order_by_secondary_identifier_result]
      end

      def cancel_order(cafe_press_order_id, options = {})
        hash = { SalesOrderNo: cafe_press_order_id, PartnerID: @partner_id }
        send_request(:cancel_cp_sales_order, hash)
      end

      def get_order_status(cafe_press_order_id, options = {})
        hash = { OrderNo: cafe_press_order_id, PartnerID: @partner_id }
        response = send_request(:get_cp_sales_order_status, hash)
        response[:get_cp_sales_order_status_response][:get_cp_sales_order_status_result]
      end

      def get_shipping_info(cafe_press_order_id, options = {})
        hash = { SalesOrderNo: cafe_press_order_id, PartnerID: @partner_id }
        response = send_request(:get_shipment_info, hash)
        response[:get_shipment_info_response][:get_shipment_info_result]
      end

      private
      def requires!(hash, *keys)
        keys.each do |key|
          raise ArgumentError, "Missing required parameter: #{key}" unless hash.include?(key)
        end
      end

      def endpoint(test)
        if test
          CafePress::SimpleOrderAPI::TEST_ENDPOINT
        else
          CafePress::SimpleOrderAPI::LIVE_ENDPOINT
        end
      end

      def send_request(method, message)
        response = @savon_client.call(method, message: message)
        response.body
      rescue Savon::SOAPFault => e
        raise InvalidRequestError, e.to_s
      rescue => e
        # SystemError, Errno, ...
        raise ConnectionError, e.to_s
      end

      def include_partner_id(hash ={})
        unless hash.has_key?(:PartnerID)
          hash[:PartnerID] = @partner_id
        end
        hash
      end

      def cafe_press_shipping_address
        requires!(@shipping_address, :name, :address1, :city, :state, :country, :zip)
        shipping_address_hash = {}
        shipping_address_hash[:Name] = @shipping_address[:name]
        shipping_address_hash[:AddressLine1] = @shipping_address[:address1]
        shipping_address_hash[:AddressLine2] =  @shipping_address[:address2]
        shipping_address_hash[:City] =  @shipping_address[:city]
        shipping_address_hash[:CountryCodeISO] =  @shipping_address[:country]
        shipping_address_hash[:PostalCode] =  @shipping_address[:zip]
        shipping_address_hash[:State] =  @shipping_address[:state]
        shipping_address_hash[:PhoneNo] =  @shipping_address[:phone]
        shipping_address_hash
      end

      def cafe_press_line_items
        line_items_array = []
        @line_items.each do |line_item|
          requires!(line_item, :sku, :quantity, :price, :options)
          requires!(line_item[:options], :size_no, :color_no)
          line_item_hash = {}
          line_item_hash[:Quantity] = line_item[:quantity]
          line_item_hash[:Price] = line_item[:price]
          line_item_hash[:ProductID] = line_item[:sku]
          line_item_hash[:ColorNo] = line_item[:options][:color_no]
          line_item_hash[:SizeNo] = line_item[:options][:size_no]
          line_items_array << line_item_hash
        end
        line_items_array
      end

      def cafe_press_order_information
        # TODO: service_level_number too
        requires!(@order, :shipping_cost, :tax, :total)

        hash = {}
        hash[:ord] = {}
        hash[:PartnerID] = @partner_id
        hash[:ord][:ShippingCost] = @order[:shipping_cost]
        hash[:ord][:Tax] = @order[:tax]
        hash[:ord][:OrderTotal] = @order[:total]
        if @order[:options]
          hash[:ord][:ServiceLevelNo] = @order[:options][:service_level_no]
          hash[:ord][:CarrierOverrideNo] = @order[:options][:carrier_override_no]
        end
        hash
      end

      def build_order_hash
        cp_order_information = cafe_press_order_information
        cp_order_information[:ord].merge!(ShippingAddress: cafe_press_shipping_address)

        hash = secondary_info_hash
        cp_order_information[:ord][:SecondaryIdentifiers] = hash unless hash.empty?

        cp_order_information[:ord][:OrderItems]  = {}
        cp_order_information[:ord][:OrderItems][:SimpleCPOrderItem] = cafe_press_line_items
        include_partner_id(cp_order_information)
      end

      def secondary_info_hash
        hash = {}
        hash[:Code] = @order[:identification_code] if @order.include?(:identification_code)
        hash[:Identifier] = @order[:id] if @order.include?(:id)

        hash.empty? ? hash : { :SimpleSecondaryIdentifier => hash }
      end
    end # end for class Client
  end # end for module EZP
end # end for  module CafePress
