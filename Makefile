#

TARGS=gameslave.js gameslave.user.js
SUBS=gmlib

%.js: %.coffee
	@{ sed -ne "/^#\/\//s|{{{VERSION}}}|$$(git rev-parse --short HEAD || echo 0).$$(date +%Y%m%d.%H%M%S -r '$<')|g" -e "/^#\/\//s|{{{FILENAME}}}|$<|g" -e 's|^#//|//|p' '$<'; bash -xc "coffee --no-header -pc '$<'"; } > "$$(dirname '$<')/$$(basename '$<' .coffee).js"

.PHONY: all
all::	$(DIRS) $(TARGS)

.PHONY: clean
clean::
	rm -f $(TARGS)

clean all::
	for a in $(SUBS); do $(MAKE) -C "$$a" $@; done

.PHONY: st
st:
	git status --porcelain

# You need inotify-tools for this
# run "make watch" and each edit automatically compiles it
.PHONY: watch it
watch it:
	while echo .; do inotifywait *.coffee */*.coffee; done | while read -t100; do while read -t0.5; do :; done; make && printf '\a'; echo; date; echo; done

$(SUBS):
	git submodule update --init

$(TARGS):	Makefile

