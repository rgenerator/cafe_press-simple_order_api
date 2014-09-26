# CafePress::EZP

CafePress EZ Prints API client and event parser

## Overview

    require 'cafe_press/ezp/client'
    require 'cafe_press/ezp/event'

    include CafePress::EZP

    Client.webhooks.base = 'http://example.com/fulfiller/cafe_press'

    partner_id = 1234
    client = Client.new(partner_id, :name => 'rgnrtr', :address1 => '400 Lafayette St 2R', :city => 'NYC', ...)
    id = client.place_order(customer, order, order_items)

    # Handle event requests
    notice = Event::Notification.parse(request)
    notice.failure?
    notice.events.each do |e|
	  e.order.id
      e.data[:date_time]
      # ...
    end

## Installation

Add this line to your application's Gemfile:

    gem 'cafepress-ezp, :git => 'git@github.com:rgenerator/cafepress-ezp.git'

And then execute:

    $ bundle
