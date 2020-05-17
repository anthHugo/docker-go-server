# We can use such syntax to get main.go and other root Go files.
GO_FILES = $(wildcard **/*.go)

PID = /tmp/serving.pid

install: .out_docker configure build up

configure: .out_docker
	$(shell build/package/dev/configure.sh)

reset_configuration: .out_docker
	rm -f build/package/dev/.env

build: .out_docker
	@cd build/package/dev && docker-compose build  --pull --no-cache

up: .out_docker
	@cd build/package/dev && docker-compose up -d

stop: .out_docker
	@cd build/package/dev && docker-compose stop
	@cd build/package/dev && docker-compose down

logs: .out_docker
	@cd build/package/dev && docker-compose logs -f

shell: .out_docker
	@cd build/package/dev && docker-compose exec golang bash

serve: start
	fswatch -or --event=Updated . | xargs -n1 -I {} make restart

kill:
	-kill `pstree -p \`cat $(PID)\` | tr "\n" " " |sed "s/[^0-9]/ /g" |sed "s/\s\s*/ /g"`

before:
	@echo "STOPPED" && printf '%*s\n' "40" '' | tr ' ' -

start:
	go run cmd/**/*.go & echo $$! > $(PID)

restart: kill before start
	@echo "STARTED" && printf '%*s\n' "40" '' | tr ' ' -


.out_docker:
ifeq (, $(shell which docker))
	$(error "You must run this command outside the docker container")
endif

.PHONY: serve restart kill before start .configure