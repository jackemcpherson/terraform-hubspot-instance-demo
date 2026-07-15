# Contributing

Install the repository's exact toolchain versions, which `make check` verifies:

- Go 1.26.5
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

Every schema change must preserve the ten-property Free-tier budget, stable map
keys, non-sensitive provider inputs, exact provider pin, generated module docs,
and successful OpenTofu and Terraform validation. Add rejection coverage for new
module constraints. Live plans and applies use the disposable demo portal only;
credentials never enter HCL, logs, commits, or state.
