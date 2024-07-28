#!/bin/sh

set -o errexit

bundle exec rake daily_mission_processing:reset_status