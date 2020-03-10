# We can use such syntax to get main.go and other root Go files.
GO_FILES = $(wildcard *.go)

PID = /tmp/serving.pid

install: .out_docker
	docker-compose up -d

stop: .out_docker
	docker-compose stop
	docker-compose down

logs: .out_docker
	docker-compose logs -f

shell: .out_docker
	docker-compose exec golang bash

serve: start
	fswatch -or --event=Updated . | xargs -n1 -I {} make restart

kill:
	-kill `pstree -p \`cat $(PID)\` | tr "\n" " " |sed "s/[^0-9]/ /g" |sed "s/\s\s*/ /g"`

before:
	@echo "STOPPED" && printf '%*s\n' "40" '' | tr ' ' -

start:
	go run $(GO_FILES) & echo $$! > $(PID)

restart: kill before start
	@echo "STARTED" && printf '%*s\n' "40" '' | tr ' ' -


.out_docker:
ifeq (, $(shell which docker))
	$(error "You must run this command outside the docker container")
endif

.PHONY: serve restart kill before start