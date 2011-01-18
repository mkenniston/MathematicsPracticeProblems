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
# Test the ProblemMaker parent class

require 'ProblemMaker'

describe MathematicsPracticeProblems::ProblemMaker do
  before(:each) do
    @maker = MathematicsPracticeProblems::ProblemMaker.new
  end

  it "should start with default options" do
    @maker.options[:columns].should == 2
    @maker.options[:rows].should == 5
    @maker.options[:pages].should == 100
    @maker.options[:name].should == "test"
  end

  it "should override options correctly" do
    maker = MathematicsPracticeProblems::ProblemMaker.new(
                { :pages=>27, :rows=>10 })
    maker.options[:columns].should == 2
    maker.options[:rows].should == 10
    maker.options[:pages].should == 27
    maker.options[:name].should == "test"
  end

  it "should return a fixed exercise when not overridden" do
    @maker.generate.should == ["alpha", "bravo", "charlie"]
  end

  it "should return a fixed format when not overrideen" do
    @maker.format([]).should == ["formatted question", "formatted answer"]
  end

  it "should return valid random numbers when not injected" do
    (1..100).each do
      x = @maker.random_int 10
      x.should < 10
      x.should >= 0
    end
  end

  it "should return specified random numbers when injected" do
    @maker.inject_random_values [1, 2, 30, 400, 5000]
    @maker.random_int(100).should == 1
    @maker.random_int(100).should == 2
    @maker.random_int(100).should == 30
    @maker.random_int(100).should == 400
    @maker.random_int(100).should == 5000
    @maker.random_int(100).should == 1
    @maker.random_int(100).should == 2
  end

  it "should inject :min and :max correctly" do
    @maker.inject_random_values [:min, :max]
    @maker.random_int(99).should == 0
    @maker.random_int(99).should == 98
  end

end  # MathematicsPracticeProblems::ProblemMaker
