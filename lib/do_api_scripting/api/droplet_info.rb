# frozen_string_literal: true

require 'prolog/dry_types'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  module API
    # Attributes of a DO Droplet to be reported on via our API.
    class DropletInfo < Dry::Struct::Value
      attribute :id, Types::Coercible::Int
      attribute :name, Types::Strict::String
      attribute :created_at, Types::Json::Time
      attribute :public_ip, Types::Strict::String # custom type?
      attribute :region_name, Types::Strict::String
      attribute :size_slug, Types::Strict::String
      attribute :status, Types::Strict::String
    end # class DoApiScripting::API::DropletInfo
  end
end
