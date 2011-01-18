#!/home/msk/jruby/jruby-1.5.5/bin/jruby

# Copyright 2011 Michael S. Kenniston
# (mike@MathematicsPracticeProblems.com).
#
# This file is part of MathematicsPracticeProblems.
#
# MathematicsPracticeProblems is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# MathematicsPracticeProblems is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero
# General Public License for more details.  
#
# You should have received a copy of the GNU Affero General Public License
# along with MathematicsPracticeProblems.  If not, see
# <http://www.gnu.org/licenses/>.

#
# Parent class for generating problems of any type.

module MathematicsPracticeProblems

class ProblemMaker 
  attr_reader :options  # for testing

  def initialize(options = {})
    @random_values = nil
    @options = { :name => "test",
                 :rows => 5,
                 :columns => 2,
                 :pages => 100,
               }.merge(options)
  end

  def inject_random_values(values)
    @random_values = values
    @random_index = -1
  end

  def random_int(max)
    if @random_values == nil
      return rand(max)
    end
    @random_index = (@random_index + 1) % @random_values.length
    result = @random_values[@random_index]
    return 0 if result == :min
    return max-1 if result == :max
    return result
  end

  # override this in each child subclass
  def generate
    return ["alpha", "bravo", "charlie"]
  end

  # override this in each child subclass
  def format prob
    return ["formatted question", "formatted answer"]
  end
end

end  # module MathematicsPracticeProblems
