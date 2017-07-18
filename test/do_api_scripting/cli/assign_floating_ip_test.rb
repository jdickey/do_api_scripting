# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli/assign_floating_ip'

module DoApiScripting
  describe 'CLI "assign_floating_ip" command' do
    let(:cli_options) { { 'droplet-id': droplet_id } }
    let(:droplet_id) { '87654321' }
    let(:out_streams) do
      out, err = capture_io { the_cli.assign_floating_ip new_ip }
      Struct.new(:err, :out).new err, out
    end
    let(:the_cli) { CLI.new [], cli_options }

    describe 'with a new IP address specified' do
      let(:new_ip) { '128.256.256.1' } # NOTE: Invalid IP address, d'oh!

      describe 'with a value defined for ENV["DO_API_TOKEN"]' do
        before do
          ENV['DO_API_TOKEN'] ||= '0123456789abcdef' * 4 # NOTE: DUMMY VALUE
        end

        it 'produces no error output' do
          expect(out_streams.err).must_be :empty?
        end

        it 'produces a DUMMIED message containing the Droplet ID and new IP' do
          expr = /Would assign Droplet ([0-9A-Fa-f]{8}) to IP #{new_ip}\.\n/
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
    end # describe 'with a new IP address specified'

    describe 'with a new IP address erroneously omitted' do
      let(:new_ip) { nil } # oops...

      it 'reports being called with no arguments' do
        expected = [
          %w[ERROR: "do_api assign_floating_ip" was called with no
             arguments].join(' '),
          'Usage: "do_api assign_floating_ip IP_ADDRESS -d, ' \
            '--droplet-id=DROPLET-ID"'
        ]
        skip 'No checking of new IP address for dummied command output'
        lines = out_streams.err.lines
        expect(lines).must_equal expected
      end
    end # describe 'with a new IP address erroneously omitted'
  end # describe 'CLI "assign_floating_ip" command'
end
