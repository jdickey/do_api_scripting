# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    describe 'API::AllDroplets' do
      let(:described_class) { API::AllDroplets }
      let(:api_token) { :dummy_api_token }

      describe 'has a .call method' do
        describe 'that, supplied a valid API token, returns an object that' do
          let(:call_result) { described_class.call api_token: api_token }

          it 'returns an object whose :droplets is an array of objects' do
            expect(call_result.respond_to?(:droplets)).must_equal true
            expect(call_result.droplets.length).must_be :>=, 0
          end
        end # describe 'that, supplied a valid API token, returns an object...'
      end # describe 'has a .call method'
    end # describe 'API::AllDroplets'
  end
end
