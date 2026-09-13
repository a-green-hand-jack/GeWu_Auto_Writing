# Infrastructure Smoke Workflow

TODO: replace during implementation.

Temporary Phase-0 probe only:

1. Load the `runtime-smoke` skill when explicitly asked for an infrastructure check.
2. Run `paperwriter-infra-check --check`.
3. Return exactly `PAPERWRITER_INFRA_OK` when the command succeeds.

This workflow is infrastructure-only and is not product behavior.
