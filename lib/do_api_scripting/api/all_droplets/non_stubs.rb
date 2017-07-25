# frozen_string_literal: true

require 'excon'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Class uses DO API to retrieve list of all Droplets owned by user
    class AllDroplets
      # Class encapsulating sending request to/receiving response from DO API.
      class DataRequest
        # Make the API request without applying stubs.
        module NonStubs
          def self.request(headers:, url:)
            Excon.get(url, headers: headers)
          end
        end
      end # class DoApiScripting::API::AllDroplets::DataRequest
    end # class DoApiScripting::API::AllDroplets
  end
end
