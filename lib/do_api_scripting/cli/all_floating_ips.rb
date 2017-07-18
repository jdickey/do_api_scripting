# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'all_floating_ips', 'Summarise all Floating IPs owned by the user'

    def all_floating_ips
      say fip_message
    end

    private

    # Reek says this is a :reek:UtilityFunction. Some things don't use state.
    def fip_message
      parts = ['Would summarise all Floating IPs owned by PAT ', '.']
      parts.join(ENV['DO_API_TOKEN'].to_s)
    end
  end # class DoApiScripting::CLI
end
