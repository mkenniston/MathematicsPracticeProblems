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
# Test the LowestTerms class

require "LowestTerms"

describe MathematicsPracticeProblems::LowestTerms do
  def fill_results(maker)
    @results = []
    (1..1000).each do
      @results << maker.generate
    end
    @count_zero = 0
    @count_one = 0
    @count_reducible = 0
    @count_irreducible = 0
    @results.each do |frac|
      q_num, q_den, a_num, a_den = frac
      if q_num == 0
        @count_zero += 1
      elsif q_num == q_den
        @count_one += 1
      elsif q_num != a_num or q_den != a_den
        @count_reducible += 1
      else
        @count_irreducible += 1
      end
    end
  end

  before(:each) do
  end

  it "should generate only valid fractions" do
    maker = MathematicsPracticeProblems::LowestTerms.new({ :limit => 100})
    fill_results maker
    @results.each do |frac|
      q_num, q_den, a_num, a_den = frac
      q_num.should >= 0
      q_num.should <= 100
      q_den.should >= 1
      q_den.should <= 100
      next if q_num == 0 or q_num == q_den
      gcd = q_num / a_num
      q_num.should == gcd * a_num
      q_den.should == gcd * a_den
    end
  end

  it "should generate fractions in each category in appropriate proportion" do
    maker = MathematicsPracticeProblems::LowestTerms.new({ :limit => 100})
    fill_results maker
    @count_zero.should > 0
    @count_one.should > 0
    @count_reducible.should > 0
    @count_irreducible.should > 0
    @count_irreducible.should > @count_zero
    @count_irreducible.should > @count_one
    @count_irreducible.should < @count_reducible
  end

  it "should suppress zero when asked" do
    maker = MathematicsPracticeProblems::LowestTerms.new(
                { :limit => 100,
                  :include_zero => false,
                })
    fill_results maker
    @count_zero.should == 0
    @count_one.should > 0
    @count_reducible.should > 0
    @count_irreducible.should > 0
  end

  it "should suppress one when asked" do
    maker = MathematicsPracticeProblems::LowestTerms.new(
                { :limit => 100,
                  :include_one => false,
                })
    fill_results maker
    @count_zero.should > 0
    @count_one.should == 0
    @count_reducible.should > 0
    @count_irreducible.should > 0
  end

  it "should suppress irreducible when asked" do
    maker = MathematicsPracticeProblems::LowestTerms.new(
                { :limit => 100,
                  :include_irreducible => false,
                })
    fill_results maker
    @count_zero.should > 0
    @count_one.should > 0
    @count_reducible.should > 0
    @count_irreducible.should == 0
  end

end  # MathematicsPracticeProblems::LowestTerms

