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

require 'rational'
require 'ProblemMaker'

module MathematicsPracticeProblems

class LowestTerms < ProblemMaker
  def initialize(options = {})
    super
    @options.merge!({ :limit => 20,
                      :include_zero => true,
                      :include_one => true,
                      :include_irreducible => true,
                    })
    @options.merge!(options)
    # set up relative amounts of different types of fractions
    num_zero = @options[:include_zero] ? 1 : 0
    num_one = @options[:include_one] ? 1: 0
    num_reducible = 23
    num_irreducible = @options[:include_irreducible] ? 5 : 0
    @threshold_zero = num_zero
    @threshold_one = @threshold_zero + num_one
    @threshold_reducible = @threshold_one + num_reducible
    @threshold_irreducible = @threshold_reducible + num_irreducible
  end

  def generate
    limit = @options[:limit]
    which = 1 + random_int(@threshold_irreducible)
    if which <= @threshold_zero
      den = 1 + random_int(limit)
      num = 0
      return [num, den, 0, 1]
    elsif which <= @threshold_one
      den = 1 + random_int(limit)
      num = den
      return [num, den, 1, 1]
    elsif which <= @threshold_reducible
      # guaranteed reducible
      begin
        big = 2 + random_int(limit/3)
        a = 1 + random_int(limit/big)
        b = 1 + random_int(limit/big)
        num = big * [a, b].min
        den = big * [a, b].max
      end until den != num
      gcd = num.gcd den
      return [num, den, num/gcd, den/gcd]
    else
      # guaranteed not reducible
      begin
        a = 1 + random_int(limit)
        b = 1 + random_int(limit)
      end until (a.gcd b) == 1
      num = [a, b].min
      den = [a, b].max
      return [num, den, num, den]
    end
  end

  def format prob
    q_num, q_den, a_num, a_den = prob
    question = "Reduce to lowest terms: " +
               "\\[\\frac{#{q_num}}{#{q_den}}=\\hspace{3em}\\]"
    if a_num == 0
      answer = "\\[0\\]"
    elsif a_num == a_den
      answer = "\\[1\\]"
    else
      answer = "\\[\\frac{#{a_num}}{#{a_den}}\\]"
    end
    [question, answer]
  end

end  # class LowestTerms
end  # module MathematicsPracticeProblems
