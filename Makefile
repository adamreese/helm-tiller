HELM_HOME ?= $(helm home)
HELM_HOME := ${HOME}/.helm

.PHONY: install
install:
	cp -a . $(HELM_HOME)/plugins/helm-tiller

.PHONY: link
link:
	ln -s ${PWD} $(HELM_HOME)/plugins/helm-tiller

.PHONY: unlink
unlink:
	unlink $(HELM_HOME)/plugins/helm-tiller
