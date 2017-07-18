# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli'

module DoApiScripting
  describe 'CLI' do
    it 'uses "help" as the default command' do
      expect(CLI.default_command).must_equal 'help'
    end
  end # describe 'CLI'
end
