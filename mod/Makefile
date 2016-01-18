#

TARGS=xorbit.js
SUBS=

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
	inotifywait -mr -eclose_write -emove -emodify --excludei '\.js$$' . | while read -t1000 why; do while echo "$$why" && read -t0.5 why; do :; done; make && printf '\a'; echo; date; echo; done

$(SUBS):
	git submodule update --init

$(TARGS):	Makefile

