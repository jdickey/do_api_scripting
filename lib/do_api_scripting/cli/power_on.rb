# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'power_on', 'Power on an existing Droplet with a specific ID'
    method_option :"droplet-id", required: true, aliases: '-d',
                                 desc: 'Droplet ID to rename (REQUIRED)'

    def power_on
      say "Would power on Droplet #{options['droplet-id']}."
    end
  end # class DoApiScripting::CLI
end
