# CafePress::SimpleOrderAPI

CafePress EZ Prints API client and event parser

## Overview
```
    require 'cafe_press/simple_order_api/client'

    client = Client.new(partner_id, options = {})
    id = client.create_order(order_id, shipping_address, line_items, options = {})
```
## Installation

Add this line to your application's Gemfile:
```
    gem 'cafe_press-simple_order_api', :git => 'git@github.com:rgenerator/cafe_press-simple_order_api.git'
```
And then execute:

    $ bundle