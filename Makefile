# Driver script
# AM Dec 2017
# what it does:
# Cleanse and run all scripts, and generate a report.
# usage: make all OR make clean

# run from top to bottom
all: doc/Final_report.md

# perform wordcout on novels. Create a rule.
data/raw_data.csv: scripts/Data_import.py
	python scripts/Data_import.py 'https://query.data.world/s/S5I_aMQV9aJMq2_o3qMmrvOMru1Sss' data/raw_data.csv
cleanse_and_summarise: data/raw_data.csv
	python scripts/Data_cleansing.py data/raw_data.csv docs/Codebook.csv data/cleansed_data.csv results/Summary_string.csv results/Summary_numeric.csv

# create plots
createplots: cleanse_and_summarise
	python scripts/Data_eda.py data/cleansed_data.csv docs/Codebook.csv results/figures

#make Report
doc/Final_report.md: createplots
	Rscript -e "ezknitr::ezknit('scripts/Final_report.Rmd', out_dir = 'docs')"

# clean intermediate results
clean:
	rm -rf results/*
	rm docs/Final_report.*
	rm data/cleansed_data.csv
