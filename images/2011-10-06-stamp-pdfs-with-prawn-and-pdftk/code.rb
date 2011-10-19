require 'prawn'
Prawn::Document.generate('content.pdf', :top_margin => 126, :right_margin => 72, :bottom_margin => 72, :left_margin => 72) do |pdf|
  pdf.text "Sustainability report for Acme", :size => 18
  pdf.move_down 12
  pdf.text "Executive summary", :style => :bold
  pdf.move_down 12
  pdf.text "Lorem ipsum"
  pdf.start_new_page
  pdf.text "Analysis"
  pdf.move_down 12
  pdf.table([['Lorem', 'ipsum'], ['sit', 'amet']], :width => 468, :header => true)
  pdf.number_pages "Page <page> of <total>", :at => [432, -4], :width => 100
end

require 'posix/spawn'
::POSIX::Spawn::Child.new 'pdftk', 'content.pdf', 'stamp', 'template.pdf', 'output', 'final.pdf'
