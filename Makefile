.PHONY neighbors:
neighbors: GCF_000699465.1_bsubJH642.gff
	/usr/bin/Rscript get_neighbors.R

GCF_000699465.1_bsubJH642.gff: download_genome.py
	./download_genome.py -i gff3 -p GCF_000699465.1_bsubJH642 GCF_000699465.1

.PHONY style:
style:
	Rscript -e 'styler::style_dir("./")'
	black ./

README.md: README.org
	pandoc -o README.md README.org
	# pandoc -f gfm -o README.md README.org
