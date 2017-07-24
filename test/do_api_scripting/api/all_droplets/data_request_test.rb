# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets/data_request'
require 'do_api_scripting/api/all_droplets/stubs'

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
          end # describe 'responds to'
        end # describe 'has a .get method returning an object that'
      end # describe 'DoApiScripting::API::AllDroplets::DataRequest'
    end # class DoApiScripting::API::AllDroplets
  end
end
