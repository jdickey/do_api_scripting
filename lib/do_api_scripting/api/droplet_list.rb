# frozen_string_literal: true

require 'prolog/dry_types'

require_relative './droplet_info'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Container class returning information about Droplets from API.
    class DropletList < Dry::Struct::Value
      attribute :droplets, Types::Strict::Array.member(DropletInfo)
      attribute :status, Types::Strict::Int
    end # class DoApiScripting::API::DropletList
  end
end
