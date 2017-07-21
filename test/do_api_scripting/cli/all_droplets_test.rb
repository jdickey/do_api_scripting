# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli/all_droplets'

module DoApiScripting
  describe 'CLI "all_droplets" command' do
    let(:out_streams) do
      out, err = capture_io { CLI.new.all_droplets }
      Struct.new(:err, :out).new err, out
    end

    describe 'with a value defined for ENV["DO_API_TOKEN"]' do
      before do
        ENV['DO_API_TOKEN'] ||= '0123456789abcdef' * 4 # NOTE: DUMMY VALUE
      end

      it 'produces no error output' do
        expect(out_streams.err).must_be :empty?
      end

      # Support class to match a (single- or multiple-)droplet table.
      # This probably should be a custom matcher.
      class MatchInfoTable
        def self.call(dump_str:)
          new(dump_str).call
        end

        def call
          horizontal_borders? && lines_start_with_border? && lines_have_headers?
        end

        protected

        def initialize(dump_str)
          @lines = dump_str.lines.map(&:rstrip)
          @parts = @lines[1..-2].map { |line| line.split('|').map(&:strip) }
          self
        end

        private

        attr_reader :lines, :parts

        HEADERS = ['ID', 'Name', 'Status', 'Created At', 'Size', 'Public IP',
                   'Region Name'].freeze
        private_constant :HEADERS

        def horizontal_borders?
          ret = lines.first == lines.last
          chars = Set.new(lines.first.split('+').join.chars)
          ret && (chars.to_a == ['-'])
        end

        def lines_have_headers?
          actual = parts.map { |part| part[1] }
          actual == HEADERS
        end

        def lines_start_with_border?
          segments = Set.new parts.map(&:first)
          segments.to_a == ['']
        end
      end # class MatchInfoTable

      tag :focus
      it 'produces a table-formatted message describing the droplet' do
        expect(MatchInfoTable.call(dump_str: out_streams.out)).must_equal true
      end
    end # describe 'with a value defined for ENV["DO_API_TOKEN"]'

    describe 'with no value defined for ENV["DO_API_TOKEN"]' do
      before do
        @old_token = ENV.delete 'DO_API_TOKEN'
      end

      after do
        ENV['DO_API_TOKEN'] = @old_token
      end

      it 'raises an ApiKeyMissing error' do
        skip 'No checking of DO_API_TOKEN for dummied command output'
        # error_class = DoApiScripting::CLIConfig::ApiKeyMissing
        error_class = RuntimeError
        expect { out_streams }.must_raise error_class
      end
    end # describe 'with no value defined for ENV["DO_API_TOKEN"]'
  end # describe 'CLI "all_droplets" command'
end
