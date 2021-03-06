.PHONY: create-cdn-route-service
create-cdn-route-service:
	$(if ${DOMAIN},,$(error Must specify DOMAIN))
	cf create-service cdn-route cdn-route router_cdn -c '{"headers": ["*"], "domain": "www.${DOMAIN},api.${DOMAIN},search-api.${DOMAIN},assets.${DOMAIN}"}'

.PHONY: docker-build
docker-build:
	$(if ${RELEASE_NAME},,$(eval export RELEASE_NAME=$(shell git describe)))
	@echo "Building a docker image for ${RELEASE_NAME}..."
	docker build -t digitalmarketplace/router .
	docker tag digitalmarketplace/router digitalmarketplace/router:${RELEASE_NAME}

.PHONY: docker-push
docker-push:
	$(if ${RELEASE_NAME},,$(eval export RELEASE_NAME=$(shell git describe)))
	docker push digitalmarketplace/router:${RELEASE_NAME}
