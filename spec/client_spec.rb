require 'spec_helper'

RSpec.describe CafePress::SimpleOrderAPI::Client do

     let(:partner_id){'G3nEr@+0R'}

     let(:line_items) do
       [{:quantity=>1, :price=>"18.12", :sku=>"459995762", :shipping_cost=>0.0, :options=>{:color_no=>6, :size_no=>4}}]
     end

     let(:shipping_adddress) do
      {:name=>"Freddy Krueger", :address1=>"550 Madison Ave 15th Fl", :address2=>"", :city=>"New York", :country=>"US", :zip=>"212 555 1212", :state=>"NY", :phone=>"212 555 1212"}
    end

     let(:order) do
       {:order => {:id=>"EB68E2B6BF1", :identification_code=>"GNTR", :shipping_cost=>"3.98", :tax=>"1.50", :total=>"18.47", :options=>{:service_level_no=>"0", :carrier_override_no=>"0"}}}
     end

     let(:client){described_class.new(partner_id)}

     context "create_order method" do
       context "input parameter validations" do

         it "should validate order shipping_cost" do
          order[:order].delete(:shipping_cost)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: shipping_cost/)
         end

         it "should validate order tax" do
          order[:order].delete(:tax)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError, /Missing required parameter: tax/)
         end

         it "should validate order total" do
          order[:order].delete(:total)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: total/)
         end

         it "should validate shipping_address name" do
          shipping_adddress.delete(:name)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: name/)
         end

          it "should validate shipping_address address1" do
          shipping_adddress.delete(:address1)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: address1/)
         end


          it "should validate shipping_address city" do
          shipping_adddress.delete(:city)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: city/)
         end


          it "should validate shipping_address state" do
          shipping_adddress.delete(:state)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: state/)
         end


         it "should validate shipping_address country" do
          shipping_adddress.delete(:country)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: country/)
         end

         it "should validate shipping_address zip" do
          shipping_adddress.delete(:zip)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: zip/)
         end

         it "should validate line_items sku" do
          line_items.first.delete(:sku)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: sku/)
         end

         it "should validate line_items quantity" do
          line_items.first.delete(:quantity)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: quantity/)
         end

         it "should validate line_items price" do
          line_items.first.delete(:price)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: price/)
         end

         it "should validate line_items options size_no" do
          line_items.first[:options].delete(:size_no)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: size_no/)
         end

         it "should validate line_items options color_no" do
          line_items.first[:options].delete(:color_no)
          expect{client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(ArgumentError,  /Missing required parameter: color_no/)
         end
       end #end for context "input parameter validations" do

       context "making API call with correct information" do
         it "should respond with success" do
           order[:order][:id] = order[:order][:id] + rand(1000000).to_s
           response = client.create_order(order[:order][:id], shipping_adddress, line_items, order)
           puts response
           expect(response).to have_key(:order_no)
         end
       end

      context "making API call with incorrect information" do
         it "should respond with error if resend already created order id" do
           expect {client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(Savon::SOAPFault,/SaveOrderHeaderASSOCIATE_ORDER_WITH_EXTERNAL_SALESORDER_PROVIDERViolation/)
         end

         it "should respond with error if identification_code is incorrect" do
         	order[:order].delete(:identification_code)
          expect {client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(Savon::SOAPFault,/VerifyOrderDetails - SecondaryIdentifierCode  is not a valid value/)
         end

         it "should respond with error if identification_code is incorrect" do
         	client = described_class.new("incorrect partner id")
          expect {client.create_order(order[:id], shipping_adddress, line_items, order)}.to raise_error(Savon::SOAPFault,/PartnerID does not have access to execute this call./)
         end
       end

     end

end
