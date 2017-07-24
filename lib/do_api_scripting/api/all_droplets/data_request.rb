# frozen_string_literal: true

require 'excon'
require 'json'

require_relative './non_stubs'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      # Class encapsulating sending request to/receiving response from DO API.
      class DataRequest
        def self.get(auth_header: :from_env, request_module: NonStubs)
          new(auth_header, request_module).get
        end

        def get
          resp = stubs.request(headers: headers, url: URL)
          body = JSON.parse(resp.body, symbolize_names: true)
          Struct.new(:status, :body).new resp.status, body
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
