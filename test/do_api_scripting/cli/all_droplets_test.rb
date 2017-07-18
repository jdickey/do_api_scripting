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

      it 'produces a DUMMIED message containing $DO_API_TOKEN' do
        expr = /Would summarise all Droplets owned by PAT ([0-9A-Fa-f]{64})\n/
        actual = out_streams.out.match(expr)
        expect(actual[1]).must_equal ENV['DO_API_TOKEN']
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
