require 'rexml/document'

module CafePress
  module SimpleOrderAPI
    module Client
      class OrderRequest
        HEADERS = { 'Content-Type' => 'application/xml' }
        attr_accessor :partner_id, :order, :shipping_address, :line_items, :options

        def initialize(partner_id)
          @partner_id = partner_id
        end

        def create_order(order, shipping_address, line_items, options = {})
          @order = order
          @shipping_address = shipping_address
          @line_items = line_items
          @options = options
        end

        def cancel_order(order_id)

        end

        def get_status(order_id)

        end

        protected

        def build_create_order_xml
          xml = Builder.new
          xml.instruct!
          xml.partnerid = @partner_id
          xml.ord { build_order_xml(xml) }
          xml.target!
        end

        def build_order_xml(xml)
          xml.ord do
            xml.order_total = @order.
          end
        end

      end # end for class OrderRequest
    end # end for module Client
  end # end for module SimpleOrderAPI
end # end for module CafePress