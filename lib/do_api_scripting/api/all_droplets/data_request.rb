# frozen_string_literal: true

require 'chamber'
require 'excon'
require 'json'

require_relative './non_stubs'

# This **must** be done before any Chamber environment is accessed. Repeated
# calls to `Chamber.load` apparently (and logically) are harmless, only adding a
# performance penalty in the event of large Chamber config files being parsed.

Chamber.load basepath: "#{ENV['PWD']}/exe"

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      # Class encapsulating sending request to/receiving response from DO API.
      class DataRequest
        def self.get(auth_header: :default, request_module: NonStubs)
          new(auth_header, request_module).get
        end

        def get
          Struct.new(:status, :body).new response.status, body
        end

        protected

        def initialize(auth_header_in, stub_module)
          @stubs = stub_module
          @auth_header = auth_header_in
          @auth_header = DEFAULT_AUTH_HEADER if auth_header_in == :default
          @response = nil
          self
        end

        private

        attr_reader :auth_header, :stubs

        DEFAULT_AUTH_HEADER = "Bearer #{Chamber.env.do.api_token}"

        URL = 'https://api.digitalocean.com/v2/droplets'
        private_constant :URL

        def body
          JSON.parse(response.body, symbolize_names: true)
        end

        def headers
          {
            'Content-Type': 'application/json',
            'Authorization': auth_header
          }
        end

        def response
          @response ||= stubs.request(headers: headers, url: URL)
        end
      end # class DoApiScripting::API::AllDroplets::DataRequest
    end # class DoApiScripting::API::AllDroplets
  end
end
