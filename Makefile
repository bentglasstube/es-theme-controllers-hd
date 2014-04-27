SYSTEMS=cavestory gba gbc nes snes
THEMES=$(patsubst %,theme/%/theme.xml,$(SYSTEMS))
BACKGROUNDS=$(patsubst %,theme/%/bg.png,$(SYSTEMS))

all: $(THEMES) $(BACKGROUNDS)

$(THEMES): theme.xml theme-colors.txt
	@echo "TODO: make $@"

$(BACKGROUNDS): $(patsubst %,./%.png,$(SYSTEMS)) overlay.png background.png
	convert -size 1920x1080 xc:white -page +0+0 background.png -page +0+$$(identify $(patsubst theme/%/bg.png,%.png,$@) |awk '{ print $$3 }' |cut -dx -f2 |xargs -n 1 echo 1080 - |bc) $(patsubst theme/%/bg.png,%.png,$@) -page +0+160 overlay.png -flatten $@

./%.png: template.svg
	inkscape $< --export-id-only --export-id $(basename $@) --export-png $@

clean:
	rm -f *.png $(THEMES) $(BACKGROUNDS)

.PHONY: all clean install
