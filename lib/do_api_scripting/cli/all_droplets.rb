# frozen_string_literal: true

require 'thor'
require 'terminal-table'

# Code to support scripting the DigitalOcean API, e.g., for use with Ansible.
module DoApiScripting
  # Logic to connect command-line interface to API command implementations.
  class CLI < Thor
    desc 'all_droplets', 'Summarise all Droplets owned by the user'

    def all_droplets
      # say "Would summarise all Droplets owned by PAT #{ENV['DO_API_TOKEN']}"
      say all_droplets_table
    end

    private

    DUMMY_DATA_ROWS = [
      ['ID', 56789012, 56789023],
      ['Name', 'amazon', 'nile'],
      ['Status', 'active', 'active'],
      ['Created At', '2017-06-21T08:20:42Z', '2017-06-22T10:07:34Z'],
      ['Size', '512mb', '512mb'],
      ['Public IP', '128.255.210.199', '128.199.173.42'],
      ['Region Name', 'Singapore 4', 'Singapore 4']
    ].freeze

    def all_droplets_table
      Terminal::Table.new(rows: DUMMY_DATA_ROWS).to_s
    end
  end # class DoApiScripting::CLI
end
