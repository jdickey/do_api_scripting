# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'rename NEW_NAME', 'Rename an existing Droplet with a specific ID'
    method_option :"droplet-id", required: true, aliases: '-d',
                                 desc: 'Droplet ID to rename (REQUIRED)'
    def rename(new_name)
      say "Would rename Droplet #{options['droplet-id']} to #{new_name}."
    end
  end # class DoApiScripting::CLI
end
