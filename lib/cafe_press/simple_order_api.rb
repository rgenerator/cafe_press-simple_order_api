module CafePress
  module SimpleOrderAPI
    VERSION = '0.0.1'

    root = File.join(File.dirname(__FILE__), 'simple_order_api', 'wsdl')
    TEST_ENDPOINT = File.join(root, 'sandbox.wsdl')

    # LIVE_ENDPOINT = File.join(root, 'production.wsdl')
    LIVE_ENDPOINT = 'https://api.cpdcprod.com/SimpleCPOrderWebService/SimpleCPOrderWS.asmx?wsdl'
  end
end
