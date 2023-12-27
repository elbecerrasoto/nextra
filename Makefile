.PHONY neighbors:
neighbors:
	/usr/bin/Rscript get_neighbors.R

.PHONY data:
data:
	./download_genome.py -i gff3 protein genome 'seq-report' cds -p GCF_000699465.1_bsubJH642 GCF_000699465.1

.PHONY style:
style:
	Rscript -e 'styler::style_dir("./")'
	black ./

README.md: README.org
	pandoc -o README.md README.org
