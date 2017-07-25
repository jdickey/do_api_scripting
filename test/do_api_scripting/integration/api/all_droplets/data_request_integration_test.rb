# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets/data_request'
require 'do_api_scripting/api/droplet_info'
require 'json'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    describe 'AllDroplets with live requests' do
      let(:req_module) { AllDroplets::DataRequest::NonStubs }
      let(:resp) { AllDroplets::DataRequest.get(request_module: req_module) }
      let(:droplet_data) { resp.body[:droplets] }
      let(:droplets) do
        droplet_data.map do |datum|
          DropletInfo.new id: datum[:id], name: datum[:name],
                          created_at: datum[:created_at],
                          size_slug: datum[:size_slug], status: datum[:status],
                          public_ip: datum.dig(:networks, :v4, 1, :ip_address),
                          region_name: datum.dig(:region, :name)
        end
      end

      it 'reports an array of droplet data' do
        expect(droplet_data).must_be_instance_of Array
      end

      it 'successfully parses each entry in the droplet-data array' do
        expect(droplets).must_be_instance_of Array
      end
    end # describe 'AllDroplets with live requests'
  end
end
