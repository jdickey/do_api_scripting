# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/api/all_droplets'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    describe 'API::AllDroplets' do
      let(:described_class) { API::AllDroplets }

      describe 'has a .call method' do
        describe 'that returns an object whose' do
          let(:call_result) { described_class.call params }
          let(:params) { { request_module: request_module } }
          let(:request_module) { API::AllDroplets::DataRequest::Stubs }

          it ':droplets reader returns an Array' do
            expect(call_result.droplets.to_ary.length).must_be :>=, 0
          end

          it ':status reader returns a positive integer' do
            expect(call_result.status.to_int).must_be :>, 0
          end
        end # describe 'that returns an object whose'
      end # describe 'has a .call method'
    end # describe 'API::AllDroplets'
  end
end
