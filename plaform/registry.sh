#!/bin/bash

set -e


docker service create --name registry --publish published=5000,target=5000 registry:2
