#!/bin/bash

css=CSS_FILE_NAME
nexstride_initial_report_md=nexstride_initial_report


readme_md=_README
 # readme
Rscript -e "rmarkdown::render('$readme_md.md', output_format = rmarkdown::html_document(),
    output_file='$readme_md.html')"  > $readme_md.log


# to generate htmls:

 # nexstride_initial_report
Rscript -e "rmarkdown::render('$nexstride_initial_report_md.md', output_format = rmarkdown::html_document(),
    output_file='$nexstride_initial_report_md.html')"  > $nexstride_initial_report_md.log
     


