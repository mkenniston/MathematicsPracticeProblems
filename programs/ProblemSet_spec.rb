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
# Test the ProblemSet class

require 'ProblemSet'

class Counter
  def initialize
    @cnt = -1
  end

  def next
    @cnt += 1
  end
end

class MockMaker
  def initialize(prefix, counter)
    @prefix = prefix
    @counter = counter
  end

  def generate
    [@prefix, @counter.next]
  end

  def format prob
    prefix, cnt = prob
    return ["#{prefix}: Q-#{cnt}", "#{prefix}: A-#{cnt}"]
  end
end

describe MathematicsPracticeProblems::ProblemSet do
  before(:each) do
    counter = Counter.new
    @pset = MathematicsPracticeProblems::ProblemSet.new(
        { :basename => "ps-test",
          :num_columns => 1,
          :probs_per_page => 3,
          :num_pages => 2,
        },
        [ MockMaker.new("X", counter),
          MockMaker.new("Y", counter),
          MockMaker.new("Z", counter),
        ])
  end

  it "should call the right ProblemMakers correctly" do
    q, a = @pset.generate_problems
    q.should == [
        "X: Q-0", "Y: Q-1", "Z: Q-2", "X: Q-3", "Y: Q-4", "Z: Q-5"]
    a.should == [
        "X: A-0", "Y: A-1", "Z: A-2", "X: A-3", "Y: A-4", "Z: A-5"]
  end

  it "should create a TeX file without blowing up" do
    @pset.print
    f = open("ps-test.tex", "r")
    f.close
  end
end  # MathematicsPracticeProblems::ProblemSet
