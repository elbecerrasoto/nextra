.PHONY style:
style:
	Rscript -e 'styler::style_dir("./")'
	black ./
