#!/home/msk/jruby/jruby-1.5.5/bin/jruby
# Copyright 2011 by Michael S. Kenniston.  All rights reserved.
#
# Given a list of problems and answers (each a fragment of TeX code),
# lay them out in pages.

class PageLayout
  def initialize(basename,
                 num_prob_cols, prob_per_page,
                 num_ans_cols, ans_per_page)
    @basename = basename
    @num_prob_cols = num_prob_cols
    @prob_per_page = prob_per_page
    @num_ans_cols = num_ans_cols
    @ans_per_page = ans_per_page
    @rule_thickness = "0.3pt"
    @hmargin = "0.5in"
    @vmargin = "0.5in"
  end

  def fill_one(f, title, items, num_cols, num_per_page)
    item_number = 0
    page_number = 0
    last_item_number = items.length - 1
    while true
      # fill one page
      break if item_number > last_item_number
      f.puts "\\newpage" if item_number > 0
      header = "{\\small #{title}" +
               "\\hfill Page #{page_number + 1}" +
               "\\hfill http://MathematicsPracticeProblems.com}"
      f.puts header
      f.puts "\\\\"
      f.puts "\\rule{\\textwidth}{#{@rule_thickness}}"
      f.puts "\\begin{multicols}{#{num_cols}}"
      (1..num_per_page).each do
        break if item_number > last_item_number
        f.puts "\\begin{minipage}{\\columnwidth}"
        f.puts "\\setlength{\\parskip}{10pt}"
        f.puts "\\vspace{0pt}"
        f.puts "\\textbf{(#{item_number + 1})}"
        f.puts "\\hspace{0pt}"
        item = items[item_number]
        f.puts "#{item}"
        f.puts "\\\\" unless item.match("\\]$")
        f.puts "\\rule{\\columnwidth}{#{@rule_thickness}}"
        f.puts "\\end{minipage}"
        item_number += 1
      end
      f.puts "\\end{multicols}"
      page_number += 1
    end
  end

  def fill(problems, answers)
    f = open("#{@basename}.tex", "w") do |f|
      f.puts "\\documentclass[12pt,leqno]{report}"
      f.puts "\\usepackage[hmargin=#{@hmargin},vmargin=#{@vmargin}]{geometry}"
      f.puts "\\usepackage{multicol}"
      f.puts "\\pagestyle{empty}"
      f.puts "\\begin{document}"
      f.puts "\\setlength{\\columnsep}{20pt}"
      f.puts "\\setlength{\\columnseprule}{0.5pt}"
      f.puts "\\setlength{\\parindent}{0pt}"
      fill_one(f, "Problem set ``#{@basename}''", problems,
               @num_prob_cols, @prob_per_page)
      f.puts "\\newpage"
      fill_one(f, "Answer key for problem set ``#{@basename}''", answers,
               @num_ans_cols, @ans_per_page)
      f.puts "\\end{document}"
    end
    system "pdflatex #{@basename}.tex"
  end
end

