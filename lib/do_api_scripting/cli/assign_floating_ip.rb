# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'assign_floating_ip IP_ADDRESS', 'Assign a Floating IP to a Droplet'
    method_option :"droplet-id", required: true, aliases: '-d',
                                 desc: 'Droplet ID to report on (REQUIRED)'
    def assign_floating_ip(ip_addr)
      say "Would assign Droplet #{options['droplet-id']} to IP #{ip_addr}."
    end
  end # class DoApiScripting::CLI
end
