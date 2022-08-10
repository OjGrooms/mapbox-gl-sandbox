PROJECTNAME = sandbox
YARN := yarn
CARGO := cargo

define cargo_bloat
	$(info ************  LARGEST RUST FUNCTIONS, DEPENDENCIES, COMPILE TIMES ************)
	cd ./src-tauri && \
	$(CARGO) bloat --release -n 10
	cd ./src-tauri && \
	$(CARGO) bloat --release --crates -n 10
	# cd ./src-tauri && \
	# $(CARGO) bloat --release --time -n 10
endef

define yarn_install
	$(YARN) install
	cd dev-tools && $(YARN) install
endef

define dev_start
  $(YARN) tauri dev
endef

define vue_devtools
	cd dev-tools && $(YARN) run dev
endef

define update_tauri
  $(YARN) install vue-cli-plugin-tauri@latest
	$(YARN) install -s @tauri-apps/api@latest
	$(YARN) install @tauri-apps/cli@latest
endef

define clean
	rm -rf node_modules
	rm -rf dist/**.*
	rm -rf src-tauri/target
	rm -rf dev-tools/node_modules
	rm -rf cypress/videos
	rm -rf cypress/screenshots
endef


PHONY: all
all: depends

PHONY: cargo-bloat
cargo-bloat: depends
	$(call cargo_bloat)

# https://tauri.studio/en/docs/usage/development/updating
PHONY: update
update:
	$(call update_tauri)

PHONY: depends
depends:
	$(call yarn_install)

PHONY: devtools
devtools:
	$(call vue_devtools)

PHONY: dev-sandbox
dev:
	make -j 2 devtools run

PHONY: run
run:
	$(call dev_start)

PHONY: clean-all
clean-all:
	$(call clean)
