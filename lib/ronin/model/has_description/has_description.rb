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

require 'ronin/model/has_description/class_methods'
require 'ronin/model/types/description'
require 'ronin/model/model'

module Ronin
  module Model
    #
    # Adds a `description` property to a model.
    #
    module HasDescription
      #
      # Adds the `description` property and {ClassMethods} to the model.
      #
      # @param [Class] base
      #   The model.
      #
      def self.included(base)
        base.send :include, Model
        base.send :extend, ClassMethods

        base.module_eval do
          # The description of the model
          property :description, Model::Types::Description
        end
      end
    end
  end
end
