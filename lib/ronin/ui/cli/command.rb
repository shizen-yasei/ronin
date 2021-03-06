#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/ui/output'
require 'ronin/ui/output/terminal'
require 'ronin/support/inflector'

require 'thor'
require 'thor/group'

module Ronin
  module UI
    module CLI
      #
      # The {Command} class inherits `Thor::Group` to provide a base-class
      # for defining sub-commands for the {CLI}.
      #
      # # Extending
      #
      # To create a new sub-command one can inherit the {Command} class.
      # The new sub-command can define multiple `class_options` and
      # `arguments` which `Thor::Group` will use to parse command-line
      # arguments.
      #
      #     require 'ronin/ui/cli/command'
      #
      #     module Ronin
      #       module UI
      #         module CLI
      #           module Commands
      #             class MyCommand < Command
      #
      #               desc 'My command'
      #
      #               # command options
      #               class_option :stuff, :type => :boolean
      #               class_option :syntax, :type => :string
      #               class_option :includes, :type => :array
      #
      #               # command arguments
      #               argument :path
      #
      #               #
      #               # Executes the command.
      #               #
      #               def execute
      #                 print_info "Stuff enabled" if options.stuff?
      #
      #                 if options[:syntax]
      #                   print_info "Using syntax #{options[:syntax]}"
      #                 end
      #
      #                 if options[:includes]
      #                   print_info "Including:"
      #                   print_array options[:includes]
      #                 end
      #               end
      #
      #             end
      #           end
      #         end
      #       end
      #     end
      #
      # # Running
      #
      # To run the sub-command from Ruby, one can call the `start` class
      # method with the options and arguments to run the sub-command with.
      #
      #     MyCommand.start(
      #       {:stuff => true, :syntax => 'bla', :includes => ['other']},
      #       ['some/file.txt']
      #     )
      #
      # To ensure that your sub-command is accessible to the `ronin`
      # command, make sure that the ruby file the sub-command is defined
      # within is in the `ronin/ui/cli/commands` directory of a
      # Ronin library. If the sub-command class is named 'MyCommand'
      # it's ruby file must also be named 'my_command.rb'.
      #
      # To run the sub-command using the `ronin` command, simply specify
      # it's underscored name:
      #
      #     ronin my_command some/file.txt --stuff --syntax bla --includes one two
      #
      class Command < Thor::Group

        include Thor::Actions
        include Output::Helpers

        class_option :verbose, :type => :boolean,
                               :default => false,
                               :aliases => '-v'
        class_option :quiet, :type => :boolean,
                             :default => false,
                             :aliases => '-q'
        class_option :silent, :type => :boolean,
                              :default => false,
                              :aliases => '-Q'

        class_option :color, :type => :boolean, :default => true
        class_option :no_color, :type => :boolean, :default => false

        #
        # Sets the namespace of a new {Command} class.
        #
        # @param [Class] super_class
        #   The new {Command} class.
        #
        def self.inherited(super_class)
          super_class.namespace(super_class.command_name)
        end

        #
        # Returns the name of the command.
        #
        def self.command_name
          self.name.split('::').last.underscore
        end

        #
        # Creates a new Command object.
        #
        # @param [Array] arguments
        #   Command-line arguments.
        #
        # @param [Array] opts
        #   Additional command-line options.
        #
        # @param [Hash] config
        #   Additional configuration.
        #
        def initialize(arguments=[],opts={},config={})
          super(arguments,opts,config)

          @indent = 0

          UI::Output.verbose! if self.options.verbose?
          UI::Output.quiet! if self.options.quiet?
          UI::Output.silent! if self.options.silent?

          if self.options.no_color?
            UI::Output.handler = UI::Output::Terminal::Raw
          elsif self.options.color?
            UI::Output.handler = UI::Output::Terminal::Color
          end
        end

        #
        # Default method to call after the options have been parsed.
        #
        def execute
        end

        protected

        #
        # The banner for the command.
        #
        # @return [String]
        #   The banner string.
        #
        # @since 1.0.0
        #
        def self.banner
          "ronin #{self_task.formatted_usage(self,false,true)}"
        end

        #
        # Increases the indentation out output temporarily.
        #
        # @param [Integer] n
        #   The number of spaces to increase the indentation by.
        #
        # @yield []
        #   The block will be called after the indentation has been
        #   increased. After the block has returned, the indentation will
        #   be returned to normal.
        #
        # @return [nil]
        #
        def indent(n=2)
          @indent += n

          yield

          @indent -= n
          return nil
        end

        #
        # Print the given messages with indentation.
        #
        # @param [Array] messages
        #   The messages to print, one per-line.
        #
        def puts(*messages)
          super(*(messages.map { |mesg| (' ' * @indent) + mesg.to_s }))
        end

        #
        # Prints a given title.
        #
        # @param [String] title
        #   The title to print.
        #
        def print_title(title)
          puts "[ #{title} ]\n"
        end

        #
        # Prints a section with a title.
        #
        # @yield []
        #   The block will be called after the title has been printed
        #   and indentation increased.
        #
        # @since 1.0.0
        #
        def print_section(title,&block)
          print_title(title)
          indent(&block)
        end

        #
        # Prints a given Array.
        #
        # @param [Array] array 
        #   The Array to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Array.
        #
        # @return [nil]
        #
        def print_array(array,options={})
          print_title(options[:title]) if options[:title]

          indent do
            array.each { |value| puts value }
          end

          puts if options[:title]
          return nil
        end

        #
        # Prints a given Hash.
        #
        # @param [Hash] hash
        #   The Hash to print.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :title
        #   The optional title to print before the contents of the Hash.
        #
        # @return [nil]
        #
        def print_hash(hash,options={})
          align = hash.keys.map { |name|
            name.to_s.length
          }.max

          print_title(options[:title]) if options[:title]

          indent do
            hash.each do |name,value|
              name = "#{name}:".ljust(align)
              puts "#{name}\t#{value}"
            end
          end

          puts if options[:title]
          return nil
        end

        #
        # Prints an exception and a shortened backtrace.
        #
        # @param [Exception] exception
        #   The exception to print.
        #
        # @since 1.0.0
        #
        def print_exception(exception)
          print_error exception.message

          (0..5).each do |i|
            print_error '  ' + exception.backtrace[i]
          end
        end

      end
    end
  end
end
