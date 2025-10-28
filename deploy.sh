#!/usr/bin/env bash

set -ex

cd infra/
tofu init
tofu apply
