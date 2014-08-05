#!/usr/bin/env bash

# configures nginx and inserts the node into the cluster
ruby ./initialize.rb

# will block until new app is spawned
ruby ./appSpawner.rb
