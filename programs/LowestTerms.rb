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

# Generate practice problems for single fractions which need to be
# reduced to lowest terms.

require 'PageLayout'

def choose_fraction(limit)
  a = 1 + rand(limit)
  b = 1 + rand(limit)
  num = [a, b].min
  den = [a, b].max
  factor = 1 + rand(limit / den)
  return [factor * num, factor * den, num, den]
end

def set(name, limit)
  cols = 5
  rows = 10
  per_page = cols * rows
  pages = 60
  layout = PageLayout.new(name, cols, per_page, cols, per_page)
  problems = []
  answers = []
  instructions = "Reduce this fraction to lowest terms:"
  (1..(per_page * pages)).each do
    prob_num, prob_den, ans_num, ans_den = choose_fraction(limit)
    problems << "\\[\\frac{#{prob_num}}{#{prob_den}}\\]"
    answers << "\\[\\frac{#{ans__num}}{#{ans_den}}\\]"
  end

  layout.fill(problems, answers)
end

generate_set'LowestTerms-A', 20)
generate_set'LowestTerms-B', 100)
generate_set'LowestTerms-C', 1000)

