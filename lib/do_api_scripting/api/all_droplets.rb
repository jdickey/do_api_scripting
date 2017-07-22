# frozen_string_literal: true

require 'excon'
require 'prolog/dry_types'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      def self.call(api_token:)
        new(api_token).call
      end

      def call
        return_obj
      end

      protected

      def initialize(api_token)
        @api_token = api_token
      end

      # Attributes of a DO Droplet to be reported on via our API.
      class DropletInfo < Dry::Struct::Value
        attribute :id, Types::Coercible::Int
        attribute :name, Types::Strict::String
        attribute :created_at, Types::Json::Time
        attribute :public_ip, Types::Strict::String # custom type?
        attribute :region_name, Types::Strict::String
        attribute :size_slug, Types::Strict::String
        attribute :status, Types::Strict::String
      end

      # Container class returning information about Droplets from API.
      class DropletList < Dry::Struct::Value
        attribute :droplets, Types::Strict::Array.member(DropletInfo)
      end # class DropletList
      private_constant :DropletList

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

      # Reek says this is a :reek:UtilityFunction with :reek:TooManyStatements.
      # We'll fix it soon.
      def droplet_data
        Excon.stub({}, status: 200, body: JSON.dump(DUMMY_DATA))
        headers = {
          'Content-Type': 'application/json',
          'Authorization': "Bearer #{ENV['DO_API_TOKEN']}"
        }
        url = 'https://api.digitalocean.com/v2/droplets'
        resp = Excon.get(url, mock: true, headers: headers)
        Excon.stubs.clear
        JSON.parse(resp.body, symbolize_names: true)
      end

      # Reek sees this as a :reek:UtilityFunction. We'll get around to it.
      def droplet_from_datum(datum)
        DropletInfo.new id: datum[:id], name: datum[:name],
                        created_at: datum[:created_at],
                        size_slug: datum[:size_slug], status: datum[:status],
                        public_ip: datum.dig(:networks, :v4, 1, :ip_address),
                        region_name: datum.dig(:region, :name)
      end

      def return_obj
        droplets = droplet_data[:droplets].map do |datum|
          droplet_from_datum(datum)
        end
        DropletList.new droplets: droplets
      end
    end # class DoApiScripting::API::AllDroplets
  end
end
