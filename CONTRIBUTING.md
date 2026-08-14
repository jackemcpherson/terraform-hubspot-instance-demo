# Contributing

Install the repository's exact toolchain versions, which `make check` verifies:

- Go 1.26.6
- OpenTofu 1.12.3
- Terraform 1.15.8
- TFLint 0.63.1
- terraform-docs 0.24.0
- ShellCheck 0.11.0
- actionlint 1.7.12

Then run:

```sh
make check
```

Every configuration change must preserve stable map keys, secret-safe inputs,
the narrow CRM `text`/`select`, Forms, Files, and account-membership contracts,
each module's real minimum
provider release, and the cumulative root's exact provider pin. Both OpenTofu
and Terraform validation must pass. Property count is a fixture choice, not a
local quota policy.

Add rejection coverage for new module constraints. Use only the disposable demo
portal for live plans and applies. Do not put credentials in HCL, logs, commits,
or state.
