# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli/rename'

module DoApiScripting
  describe 'CLI "rename" command' do
    let(:cli_options) { { 'droplet-id': droplet_id } }
    let(:droplet_id) { '87654321' }
    let(:out_streams) do
      out, err = capture_io { the_cli.rename new_name }
      Struct.new(:err, :out).new err, out
    end
    let(:the_cli) { CLI.new [], cli_options }

    describe 'with a new name specified' do
      let(:new_name) { 'new-droplet-name' }

      describe 'with a value defined for ENV["DO_API_TOKEN"]' do
        before do
          ENV['DO_API_TOKEN'] ||= '0123456789abcdef' * 4 # NOTE: DUMMY VALUE
        end

        it 'produces no error output' do
          expect(out_streams.err).must_be :empty?
        end

        it 'produces a DUMMIED message with the Droplet ID and new name' do
          expr = /Would rename Droplet ([0-9A-Fa-f]{8}) to #{new_name}\.\n/
          actual = expr.match out_streams.out
          expect(actual[1]).must_equal droplet_id
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
    end # describe 'with a new name specified'

    describe 'with the new name erroneously omitted' do
      let(:new_name) { nil } # oops...

      it 'reports being called with no arguments' do
        expected = [
          %w[ERROR: "do_api rename" was called with no
             arguments].join(' '),
          'Usage: "do_api rename NEW_NAME -d, ' \
            '--droplet-id=DROPLET-ID"'
        ]
        skip 'No checking of new name for dummied command output'
        lines = out_streams.err.lines
        expect(lines).must_equal expected
      end
    end # describe 'with the new name erroneously omitted'
  end # describe 'CLI "rename" command'
end
