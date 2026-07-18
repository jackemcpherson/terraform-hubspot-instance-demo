.PHONY: check fmt validate test plan apply verify output destroy-plan destroy-apply registry-init registry-plan registry-apply registry-verify registry-output registry-destroy-plan registry-destroy-apply

check:
	@./scripts/check

fmt:
	@tofu fmt -recursive

validate:
	@./scripts/demo local validate

test:
	@./scripts/demo local test

plan:
	@./scripts/demo local plan

apply:
	@./scripts/demo local apply

verify:
	@./scripts/demo local verify

output:
	@./scripts/demo local output

destroy-plan:
	@./scripts/demo local destroy-plan

destroy-apply:
	@./scripts/demo local destroy-apply

registry-init:
	@./scripts/demo registry init

registry-plan:
	@./scripts/demo registry plan

registry-apply:
	@./scripts/demo registry apply

registry-verify:
	@./scripts/demo registry verify

registry-output:
	@./scripts/demo registry output

registry-destroy-plan:
	@./scripts/demo registry destroy-plan

registry-destroy-apply:
	@./scripts/demo registry destroy-apply
