# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'shutdown', 'Gracefully shut down existing Droplet with a specific ID'
    method_option :"droplet-id", required: true, aliases: '-d',
                                 desc: 'Droplet ID to shut down (REQUIRED)'

    def shutdown
      say "Would gracefully shut down Droplet #{options['droplet-id']}."
    end
  end # class DoApiScripting::CLI
end
