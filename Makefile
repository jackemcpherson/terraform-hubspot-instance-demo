.PHONY: check fmt validate test plan apply verify drift repair refresh adopt output destroy-plan destroy-apply registry-init registry-plan registry-apply registry-verify registry-drift registry-repair registry-refresh registry-adopt registry-output registry-destroy-plan registry-destroy-apply

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

drift:
	@./scripts/demo local drift

repair:
	@./scripts/demo local repair

refresh:
	@./scripts/demo local refresh

adopt:
	@./scripts/demo local adopt

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

registry-drift:
	@./scripts/demo registry drift

registry-repair:
	@./scripts/demo registry repair

registry-refresh:
	@./scripts/demo registry refresh

registry-adopt:
	@./scripts/demo registry adopt

registry-output:
	@./scripts/demo registry output

registry-destroy-plan:
	@./scripts/demo registry destroy-plan

registry-destroy-apply:
	@./scripts/demo registry destroy-apply
