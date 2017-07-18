# frozen_string_literal: true

require 'test_helper'

require 'do_api_scripting/cli'

module DoApiScripting
  VALID_COMMANDS = {
    all_droplets: false,
    all_floating_ips: false,
    assign_floating_ip: true,
    help: false,
    info: true,
    power_off: true,
    power_on: true,
    rename: true,
    shutdown: true,
    version: false
  }.freeze

  describe 'CLI "help" command' do
    let(:described_class) { CLI }
    let(:valid_commands) { VALID_COMMANDS.keys.map(&:to_s) }

    describe 'for all commands' do
      let(:out_streams) do
        out, err = capture_io do
          described_class.new.help
        end
        Struct.new(:err, :out).new err, out
      end

      it 'produces no error output' do
        expect(out_streams.err).must_be :empty?
      end

      describe 'produces standard output that' do
        let(:command_help) { out_lines[1..-2] }
        let(:out_lines) { out_streams.out.lines }

        it 'starts with a "Commands:" line' do
          expect(out_lines.first).must_equal "Commands:\n"
        end

        it 'ends with an empty line' do
          expect(out_lines.last).must_equal "\n"
        end

        it 'describes all commands' do
          actual_commands = command_help.map { |str| str.split[1] }
          expect(actual_commands).must_equal valid_commands
        end

        describe 'for each command described' do
          it 'includes usage and a description, separated by a "#" character' do
            errors = command_help.reject { |str| str.split('#').length == 2 }
            expect(errors).must_be :empty?
          end
        end # describe "for each command described"
      end # describe 'produces standard output that'
    end # describe 'for all commands'

    describe 'for the command' do
      let(:out_streams) do
        pr = proc do |command|
          out, err = capture_io do
            described_class.new.help command
          end
          Struct.new(:err, :out).new err, out
        end
        ret = {}
        valid_commands.each { |command| ret[command.to_sym] = pr.call command }
        ret
      end

      VALID_COMMANDS.each do |command, requires_droplet|
        describe command do
          let(:os) { out_streams[command.to_sym] }

          it 'produces no error output' do
            expect(os.err).must_be :empty?
          end

          it 'produces at least four lines of standard output' do
            expect(os.out.lines.count).wont_be :<, 4
          end

          describe 'produces standard output such that' do
            it 'the first line reads "Usage:" with a trailing newline' do
              expect(os.out.lines.first).must_equal "Usage:\n"
            end

            it 'the second line describes the command syntax' do
              words = os.out.lines[1].split
              expect(words[1]).must_equal command.to_s
            end

            it 'the third line contains only a newline' do
              expect(os.out.lines[2]).must_equal "\n"
            end

            if requires_droplet
              it 'requires a --droplet option' do
                expect(os.out.lines[3]).must_equal "Options:\n"
                last_line_parts = os.out.lines[4].split('#').map(&:strip)
                option_text = '-d, --droplet-id=DROPLET-ID'
                expect(last_line_parts.first).must_equal option_text
                match_ex = /Droplet ID to (.+?) \(REQUIRED\)/
                expect(last_line_parts.last).must_match match_ex
              end

              it 'has an empty sixth line' do
                expect(os.out.lines[5]).must_equal "\n"
              end
            else
              it 'does not require any options' do
                expect(os.out.lines[3]).wont_equal "Options:\n"
              end

              it 'the fourth line is not a blank line' do
                expect(os.out.lines[3]).wont_equal "\n"
              end
            end # if requires_droplet
          end # describe 'produces standard output such that'
        end # describe command
      end # VALID_COMMANDS.each
    end # describe 'for the command'
  end # describe 'CLI "help" command'
end
