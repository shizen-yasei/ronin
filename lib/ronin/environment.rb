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

#
# Loads all extensions to core Ruby classes.
#
require 'ronin/ronin'
require 'ronin/extensions'
require 'ronin/formatting/extensions'
require 'ronin/network/extensions'
require 'ronin/ui/hexdump/extensions'
require 'ronin/ui/output/helpers'

require 'chars/extensions'

#
# Includes the Ronin namespace and output helper methods.
#
include Ronin
include Ronin::UI::Output::Helpers
