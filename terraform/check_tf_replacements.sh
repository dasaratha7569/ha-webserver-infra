#!/usr/bin/env bash

set -o pipefail

# Run terraform plan and save output
terraform plan -no-color -out=tfplan > tfplan.out 2>&1

PLAN_STATUS=$?

# If terraform plan fails, stop here
if [ "$PLAN_STATUS" -ne 0 ]; then
    cat tfplan.out
    exit "$PLAN_STATUS"
fi

# Display only resources that will be replaced or destroyed
grep -E '^# .*will be (destroyed|replaced)|must be replaced' tfplan.out || true
