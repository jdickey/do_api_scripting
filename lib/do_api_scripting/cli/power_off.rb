# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'power_off',
         'Forcibly power off an existing Droplet with a specific ID'
    method_option :"droplet-id", required: true, aliases: '-d',
                                 desc: 'Droplet ID to rename (REQUIRED)'

    def power_off
      say "Would forcibly power off Droplet #{options['droplet-id']}."
    end
  end # class DoApiScripting::CLI
end
