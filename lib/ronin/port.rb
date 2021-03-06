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

require 'ronin/open_port'
require 'ronin/model'

module Ronin
  #
  # Represents a TCP or UDP port.
  #
  class Port

    include Model

    # Primary key of the port
    property :id, Serial

    # The protocol of the port (either `'tcp'` / `'udp'`)
    property :protocol, String, :set => ['tcp', 'udp'],
                                :required => true,
                                :unique_index => :protocol_port

    # The port number
    property :number, Integer, :required => true,
                               :min => 1,
                               :max => 65535,
                               :unique_index => :protocol_port

    # The open ports
    has 1..n, :open_ports

    validates_uniqueness_of :number, :scope => [:protocol]

    #
    # Converts the port to an integer.
    #
    # @return [Integer]
    #   The port number.
    #
    # @since 1.0.0
    #
    def to_i
      self.number.to_i
    end

    #
    # Converts the port to a string.
    #
    # @return [String]
    #   The port number and protocol.
    #
    # @since 1.0.0
    #
    def to_s
      "#{self.number}/#{self.protocol}"
    end

    #
    # Inspects the port.
    #
    # @return [String]
    #   The inspected port.
    #
    # @since 1.0.0
    #
    def inspect
      "#<#{self.class}: #{self}>"
    end

  end
end
