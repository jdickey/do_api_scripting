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
          def self.request(headers:, url:)
            on
            resp = Excon.get(url, request_params(headers))
            off
            resp
          end

          def self.off
            Excon.stubs.clear
          end

          def self.on
            Excon.stub({}, status: 200, body: JSON.dump(DUMMY_DATA))
          end

          def self.request_params(headers)
            { mock: true, headers: headers }
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
      end # class DoApiScripting::API::AllDroplets::DataRequest
    end # class DoApiScripting::API::AllDroplets
  end
end
