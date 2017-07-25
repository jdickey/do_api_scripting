# frozen_string_literal: true

require 'excon'
require 'prolog/dry_types'

require_relative './droplet_list'
require_relative './all_droplets/data_request'
require_relative './all_droplets/stubs'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      def self.call(request_module: DEFAULT_REQUEST_MODULE)
        new(request_module).call
      end

      def call
        return_obj
      end

      protected

      def initialize(request_module)
        @request_module = request_module
        self
      end

      private

      attr_reader :request_module

      DEFAULT_REQUEST_MODULE = API::AllDroplets::DataRequest::NonStubs
      private_constant :DEFAULT_REQUEST_MODULE

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

      # Reek says this is a :reek:UtilityFunction.
      def droplet_data
        data = DataRequest.get(request_module: request_module)
        droplets = data.body[:droplets].map do |datum|
          droplet_from_datum(datum)
        end
        { droplets: droplets, status: data.status }
      end

      # Reek sees this as a :reek:UtilityFunction. We'll get around to it.
      def droplet_from_datum(datum)
        datum2 = datum.reject { |k, _| %i[networks region].include?(k) }
        datum2[:public_ip] = datum.dig(:networks, :v4, 1, :ip_address)
        datum2[:region_name] = datum.dig(:region, :name)
        DropletInfo.new datum2
      end

      def return_obj
        DropletList.new droplet_data.to_h
      end
    end # class DoApiScripting::API::AllDroplets
  end
end
