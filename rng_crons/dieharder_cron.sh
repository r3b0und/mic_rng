#!/bin/bash

cat /dev/urandom | dieharder -g 200 -a > ~/rng/.rng_logs/$(date +"%T_%F").log

