# frozen_string_literal: true

require 'thor'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'all_droplets', 'Summarise all Droplets owned by the user'

    def all_droplets
      say "Would summarise all Droplets owned by PAT #{ENV['DO_API_TOKEN']}"
    end
  end # class DoApiScripting::CLI
end
