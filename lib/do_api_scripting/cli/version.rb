# frozen_string_literal: true

require 'thor'

require 'do_api_scripting/version'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'version', 'Display version information for utility'
    def version
      say "Version #{VERSION}"
    end
  end # class DoApiScripting::CLI
end
