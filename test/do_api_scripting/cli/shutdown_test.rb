# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli/shutdown'

module DoApiScripting
  describe 'CLI "shutdown" command' do
    let(:cli_options) { { 'droplet-id': droplet_id } }
    let(:out_streams) do
      out, err = capture_io { the_cli.shutdown }
      Struct.new(:err, :out).new err, out
    end

    describe 'with a Droplet ID specified' do
      let(:droplet_id) { '87654321' }
      let(:the_cli) { CLI.new [], cli_options }

      describe 'with a value defined for ENV["DO_API_TOKEN"]' do
        before do
          ENV['DO_API_TOKEN'] ||= '0123456789abcdef' * 4 # NOTE: DUMMY VALUE
        end

        it 'produces no error output' do
          expect(out_streams.err).must_be :empty?
        end

        it 'produces a DUMMIED message containing the Droplet ID' do
          expr = /Would gracefully shut down Droplet #{droplet_id}\.\n/
          expect(out_streams.out).must_match expr
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
    end # describe 'with a Droplet ID specified'

    describe 'with a Droplet ID inadvertently omitted' do
      let(:droplet_id) { nil }
      let(:the_cli) { CLI.new }

      it 'reports being called with no arguments' do
        expected = [
          %w[ERROR: "do_api shutdown" was called with no
             arguments].join(' '),
          'Usage: "do_api shutdown -d, --droplet-id=DROPLET-ID"'
        ]
        skip 'No checking of Droplet ID for dummied command output'
        lines = out_streams.err.lines
        expect(lines).must_equal expected
      end
    end # describe 'with a Droplet ID inadvertently omitted'
  end # describe 'CLI "shutdown" command'
end
