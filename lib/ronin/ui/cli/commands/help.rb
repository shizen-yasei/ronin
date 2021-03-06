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

require 'ronin/ui/cli/command'
require 'ronin/ui/cli/cli'

module Ronin
  module UI
    module CLI
      module Commands
        #
        # The `ronin help` command.
        #
        class Help < Command

          desc 'Displays the list of available commands or prints information on a specific command'
          argument :command, :type => :string, :required => false

          #
          # Lists the available commands.
          #
          def execute
            if self.command
              begin
                CLI.command(self.command).start(['--help'])
              rescue UnknownCommand
                print_error "unknown command #{command.dump}"
              end
            else
              print_array CLI.commands.keys.sort,
                          :title => 'Available commands'
            end
          end

        end
      end
    end
  end
end
