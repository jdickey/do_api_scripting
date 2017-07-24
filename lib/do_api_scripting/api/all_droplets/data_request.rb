# frozen_string_literal: true

require 'excon'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      # Class encapsulating sending request to/receiving response from DO API.
      class DataRequest
        # Stubbing data shouldn't be part of the core logic, should it? :P
        module Stubs
          def self.request_params(headers)
            { mock: true, headers: headers }
          end

          def self.on
            Excon.stub({}, status: 200, body: JSON.dump(DUMMY_DATA))
          end

          def self.off
            Excon.stubs.clear
          end

          DUMMY_DATA = {
            meta: { total: 3 },
            links: {},
            droplets: [
              {
                created_at: '2017-06-21T08:20:42Z',
                id: '52434906',
                name: 'suirdemo1-test',
                networks: {
                  v4: [
                    { type: 'private', ip_address: '10.130.10.113' },
                    { type: 'public', ip_address: '128.199.105.180' }
                  ],
                  v6: []
                },
                region: { name: 'Singapore 1', slug: 'sgp1' },
                size_slug: '512mb',
                status: 'active'
              },
              {
                created_at: '2017-06-22T10:07:34Z',
                id: '52569259',
                name: 'suirdemo2',
                networks: {
                  v4: [
                    { type: 'private', ip_address: '10.130.19.125' },
                    { type: 'public', ip_address: '128.199.73.100' }
                  ],
                  v6: []
                },
                region: { name: 'Singapore 1', slug: 'sgp1' },
                size_slug: '512mb',
                status: 'active'
              }
            ]
          }.freeze
          private_constant :DUMMY_DATA
        end

        def self.get(auth_header = :from_env)
          new(auth_header).get
        end

        # Reek points out that this is (temporarily) a :reek:UtilityFunction.
        def get
          Stubs.on
          url = 'https://api.digitalocean.com/v2/droplets'
          resp = Excon.get(url, stubs.request_params(headers))
          Stubs.off
          resp
        end

        protected

        def initialize(auth_header)
          @auth_header = auth_header
          if auth_header == :default
            @auth_header = "Bearer #{ENV['DO_API_TOKEN']}"
          end
          self
        end

        private

        attr_reader :auth_header

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
