# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets/data_request'
require 'do_api_scripting/api/all_droplets/stubs'
require 'do_api_scripting/api/droplet_info'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      describe 'API::AllDroplets::DataRequest' do
        let(:described_class) { DataRequest }

        describe 'has a .get method returning an object that' do
          describe 'responds to' do
            let(:obj) do
              described_class.get(request_module: DataRequest::Stubs)
            end

            it ':status, returning a value of 200' do
              expect(obj.status).must_equal 200
            end

            it ':body, returning a Hash' do
              expect(obj.body.respond_to?(:to_hash)).must_equal true
            end

            describe ':body, returning a Hash that' do
              let(:droplet_data) { obj.body[:droplets] }
              let(:droplets) do
                droplet_data.map do |datum|
                  DropletInfo.new id: datum[:id], name: datum[:name],
                                  created_at: datum[:created_at],
                                  size_slug: datum[:size_slug],
                                  status: datum[:status],
                                  public_ip: datum.dig(:networks, :v4, 1,
                                                       :ip_address),
                                  region_name: datum.dig(:region, :name)
                end
              end

              it 'has a :droplets key for an Array value' do
                expect(droplet_data.respond_to?(:to_ary)).must_equal true
              end

              it 'has a :droplets key for an Array of Droplet data' do
                expect(droplets.respond_to?(:to_ary)).must_equal true
              end
            end # describe ':body, returning a Hash that'
          end # describe 'responds to'
        end # describe 'has a .get method returning an object that'
      end # describe 'DoApiScripting::API::AllDroplets::DataRequest'
    end # class DoApiScripting::API::AllDroplets
  end
end
