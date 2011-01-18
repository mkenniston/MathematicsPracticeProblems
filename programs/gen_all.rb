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
# Given a list of ProblemMakers, create a PDF file full of generated problems.

module MathematicsPracticeProblems

def main
  maker = LowestTerms.new({:limit => 20})
  set = ProblemSet.new({:basename => 'LowestTerms-xyz-20',
                        :num_columns => 4, :probs_per_page => 28
                       }, [maker])
  set.print
  maker = LowestTerms.new({:limit => 100})
  set = ProblemSet.new({:basename => 'LowestTerms-xyz-100',
                        :num_columns => 4, :probs_per_page => 28
                       }, [maker])
  set.print
  maker = LowestTerms.new({:limit => 1000})
  set = ProblemSet.new({:basename => 'LowestTerms-xyz-1000',
                        :num_columns => 4, :probs_per_page => 28
                       }, [maker])
  set.print
end

if __FILE__ == $PROGRAM_NAME
  main
end

