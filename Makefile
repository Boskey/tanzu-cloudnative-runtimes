PORTAL_NAME = tanzu-cloudnative-runtimes
REGISTRY = localhost:5001

all: publish-workshop deploy-workshop

publish-workshop:
	imgpkg push -i $(REGISTRY)/$(PORTAL_NAME)-files:latest -f .

deploy-workshop: update-workshop
	kubectl apply -f resources/trainingportal.yaml
	STATUS=1; ATTEMPTS=0; ROLLOUT_STATUS_CMD="kubectl rollout status deployment/training-portal -n $(PORTAL_NAME)-ui"; until [ $$STATUS -eq 0 ] || $$ROLLOUT_STATUS_CMD || [ $$ATTEMPTS -eq 5 ]; do sleep 5; $$ROLLOUT_STATUS_CMD; STATUS=$$?; ATTEMPTS=$$((ATTEMPTS + 1)); done

update-workshop:
	kubectl apply -f resources/workshop.yaml

delete-workshop:
	-kubectl delete -f resources/trainingportal.yaml --cascade=foreground
	-kubectl delete -f resources/workshop.yaml

open-workshop:
	URL=`kubectl get trainingportal/$(PORTAL_NAME) -o go-template={{.status.educates.url}}`; (test -x /usr/bin/xdg-open && xdg-open $$URL) || (test -x /usr/bin/open && open $$URL) || true