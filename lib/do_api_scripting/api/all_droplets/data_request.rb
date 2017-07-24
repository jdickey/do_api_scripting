# frozen_string_literal: true

require 'excon'

require_relative './non_stubs'
require_relative './stubs'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      # Class encapsulating sending request to/receiving response from DO API.
      class DataRequest
        def self.get(auth_header: :from_env, request_module: Stubs)
          new(auth_header, request_module).get
        end

        def get
          stubs.request(headers: headers, url: URL)
        end

        protected

        def initialize(auth_header_in, stub_module)
          @stubs = stub_module
          @auth_header = auth_header_in
          if auth_header_in == :from_env
            @auth_header = "Bearer #{ENV['DO_API_TOKEN']}"
          end
          self
        end

        private

        attr_reader :auth_header, :stubs

        URL = 'https://api.digitalocean.com/v2/droplets'
        private_constant :URL

        def headers
          {
            'Content-Type': 'application/json',
            'Authorization': auth_header
          }
        end
      end # class DoApiScripting::API::AllDroplets::DataRequest
    end # class DoApiScripting::API::AllDroplets
  end
end
