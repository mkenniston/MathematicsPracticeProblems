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

class ProblemSet
  def initialize(options, maker_list)
    @options = { :basename => 'test',
                 :num_columns => 2,
                 :probs_per_page => 30,
                 :num_pages => 100,
                 :rule_thickness => "0.3pt",
                 :hmargin => "0.5in",
                 :vmargin => "0.5in",
               }.merge(options)
    @maker_list = maker_list
  end

  def fill_half(f, title, items)
    item_number = 0
    page_number = 0
    last_item_number = items.length - 1
    while true
      # fill one page
      break if item_number > last_item_number
      f.puts "\\newpage" if item_number > 0
      header = "#{title}" +
               "\\hfill " +
               "Page #{page_number + 1}"
      footer = "Copyright \\copyright\\ #{Time.now.year} " +
               "Michael S. Kenniston\\hfill " +
               "http://MathematicsPracticeProblems.com"
      f.puts "{\\small #{header}}"
      f.puts "\\\\"
      f.puts "\\rule{\\textwidth}{#{@options[:rule_thickness]}}"
      f.puts "\\begin{multicols}{#{@options[:num_columns]}}"
      (1..@options[:probs_per_page]).each do
        break if item_number > last_item_number
        f.puts "\\begin{minipage}{\\columnwidth}"
        f.puts "\\setlength{\\parskip}{10pt}"
        f.puts "\\vspace{0pt}"
        f.puts "\\textbf{(#{item_number + 1})}"
        f.puts "\\hspace{0pt}"
        item = items[item_number]
        f.puts "#{item}"
        f.puts "\\\\" unless item.match("\\]$")
        f.puts "\\rule{\\columnwidth}{#{@options[:rule_thickness]}}"
        f.puts "\\end{minipage}"
        item_number += 1
      end
      f.puts "\\end{multicols}"
      f.puts "\\vfill"
      f.puts "{\\small \\begin{center}#{footer}\\end{center}}"
      page_number += 1
    end
  end

  def write_to_file(questions, answers)
    f = open("#{@options[:basename]}.tex", "w") do |f|
      f.puts "\\documentclass[12pt,leqno]{report}"
      f.puts "\\usepackage[hmargin=#{@options[:hmargin]}," +
             "vmargin=#{@options[:vmargin]}]{geometry}"
      f.puts "\\usepackage{multicol}"
      f.puts "\\pagestyle{empty}"
      f.puts "\\begin{document}"
      f.puts "\\setlength{\\columnsep}{20pt}"
      f.puts "\\setlength{\\columnseprule}{0.5pt}"
      f.puts "\\setlength{\\parindent}{0pt}"
      fill_half(f,
                "Problem set ``#{@options[:basename]}''",
                questions)
      f.puts "\\newpage"
      fill_half(f,
                "Answer key for problem set ``#{@options[:basename]}''",
                answers)
      f.puts "\\end{document}"
    end
    system "pdflatex #{@options[:basename]}.tex"
  end

  def generate_problems
    questions = []
    answers = []
    maker_index = 0
    total_probs = @options[:num_pages] * @options[:probs_per_page]
    (1..total_probs).each do
      maker = @maker_list[maker_index]
      maker_index += 1
      maker_index = 0 if maker_index >= @maker_list.length
      prob = maker.generate
      q, a = maker.format prob
      questions << q
      answers << a
    end
    return [questions, answers]
  end

  def print
    questions, answers = generate_problems
    write_to_file(questions, answers)
  end
end

end  # module MathematicsPracticeProblems
