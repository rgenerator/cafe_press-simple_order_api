require 'cafe_press/simple_order_api'
require 'active_utils'
module CafePress
  module SimpleOrderAPI
    class Client
    include ActiveMerchant::RequiresParameters

      def initialize(partner_id, options = {})
        @partner_id = partner_id

        options = options.dup
        options[:wsdl] = end_point(options.delete(:live))
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
        puts response = @savon_client.call(:create_order, message: build_order_hash)
        puts response.inspect
        response[:create_order_response][:create_order_result]
      end

      def get_order_by_secondary_identifier(identification_code, order_id, options = {})
        hash = { IdentifierCode: identification_code, PartnerID: @partner_id, Identifier: order_id }
        @savon_client.call(:get_order_by_secondary_identifier, message: hash)
      end

      def cancel_order(cafe_press_order_id, options = {})
        hash = { SalesOrderNo: cafe_press_order_id, PartnerID: @partner_id }
        @savon_client.call(:cancel_cp_sales_order, message: hash)
      end

      def get_order_status(cafe_press_order_id, options = {})
        hash = { OrderNo: cafe_press_order_id, PartnerID: @partner_id }
        puts client.call(:get_cp_sales_order_status, message: hash)
      end

      def get_shipping_info(cafe_press_order_id, options = {})
        hash = { SalesOrderNo: cafe_press_order_id, PartnerID: @partner_id }
        @savon_client.call(:cancel_cp_sales_order, message: hash)
      end

      private
      def end_point(live)
        if live
          CafePress::SimpleOrderAPI::LIVE_ENDPOINT
        else
          CafePress::SimpleOrderAPI::TEST_ENDPOINT
        end
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
          requires!(line_item, :sku, :quantity, :price)
          requires!(line_item[:options], :size_no, :color_no)

          line_item_hash = {}
          line_item_hash[:SimpleCPOrderItem]  = {}
          line_item_hash[:SimpleCPOrderItem][:Quantity] = line_item[:quantity]
          line_item_hash[:SimpleCPOrderItem][:Price] = line_item[:price]
          line_item_hash[:SimpleCPOrderItem][:product_id] = line_item[:sku]
          line_item_hash[:SimpleCPOrderItem][:color_no] = line_item[:color_no]
          line_item_hash[:SimpleCPOrderItem][:size_no] = line_item[:size_no]
          line_items_array << line_item_hash
        end
        line_items_array
      end

      def cafe_press_order_information
        requires!(@order, :shipping_cost, :tax, :total)

        hash = {}
        hash[:ord] = {}
        hash[:PartnerID] = @partner_id
        hash[:ord][:ShippingCost] = @order[:shipping_cost]
        hash[:ord][:Tax] = @order[:tax]
        hash[:ord][:OrderTotal] = @order[:total]
        hash[:ord][:ServiceLevelNo] = @order[:service_level_no]
        hash[:ord][:CarrierOverrideNo] = @order[:carrier_override_no]
        hash
      end

      def build_order_hash
        cp_order_information = cafe_press_order_information
        cp_order_information[:ord].merge!(ShippingAddress: cafe_press_shipping_address,
                                          OrderItems: cafe_press_line_items,
                                          SecondaryIdentifiers:  secondary_info_hash)
        include_partner_id(cp_order_information)
      end

      def secondary_info_hash
        hash  = {}
        hash[:SimpleSecondaryIdentifier] = { Code: @order[:identification_code], Identifier: @order[:id] }
        hash
      end
    end # end for class Client
  end # end for module EZP
end # end for  module CafePress
