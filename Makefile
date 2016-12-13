HELM_HOME ?= $(helm home)

.PHONY: install
install:
	cp -a tiller $(HELM_HOME)/plugins
