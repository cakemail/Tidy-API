# vim: set noexpandtab ts=2 :

NAME = docker.r53.wbsrvc.com/tidy

default:
	@echo RTFMakefile

## update the base image
update:
	docker pull $(shell awk '/^FROM/ { print $$2; exit }' Dockerfile)

## build a new version
build: update
	docker build -t $(NAME):$(shell date +%Y%m%d) --rm .

prod:
	docker tag $(NAME):$(shell date +%Y%m%d) $(NAME):prod

staging:
	docker tag $(NAME):$(shell date +%Y%m%d) $(NAME):staging

push-build:
	docker push $(NAME):$(shell date +%Y%m%d)

push-prod: push-build
	docker push $(NAME):prod

push-staging: push-build
	docker push $(NAME):staging
