# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli/version'
require 'do_api_scripting/version'

module DoApiScripting
  describe 'CLI "version" command' do
    let(:out_streams) do
      out, err = capture_io { CLI.new.version }
      Struct.new(:err, :out).new err, out
    end

    it 'produces no error output' do
      expect(out_streams.err).must_be :empty?
    end

    it 'produces a message with the version identifier' do
      expr = /^Version (.+?)\n$/
      actual = out_streams.out.match(expr)
      expect(actual[1]).must_equal VERSION
    end
  end # describe 'CLI "version" command'
end
