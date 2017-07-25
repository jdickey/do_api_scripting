# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    describe 'API::AllDroplets' do
      let(:described_class) { API::AllDroplets }

      describe 'has a .call method' do
        describe 'that, supplied a valid API token, returns an object that' do
          let(:call_result) { described_class.call params }
          let(:params) { { request_module: request_module } }
          let(:request_module) { API::AllDroplets::DataRequest::Stubs }

          it 'returns an object whose :droplets is an Array' do
            expect(call_result.droplets.to_ary.length).must_be :>=, 0
          end
        end # describe 'that, supplied a valid API token, returns an object...'
      end # describe 'has a .call method'
    end # describe 'API::AllDroplets'
  end
end
