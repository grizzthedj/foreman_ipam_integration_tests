# foreman_ipam_integration_test

## Overview

Standalone cucumber project to run headless integration testing on Foreman and phpIPAM integration. Intended to be run in a development environment, but will likely be refactored later to run in a CICD pipeline.

These tests test the features in the below Foreman plugins:

https://github.com/grizzthedj/foreman_ipam  
https://github.com/grizzthedj/smart_proxy_ipam

Tests must be executed in a specific order(when running whole test suite), so they should be run using `run-tests.sh`, and not use `cucumber` directly.

## Prerequisites

1. Download latest geckodriver and add to PATH.
2. Install Bundler: 
```
gem install bundler
```
3. A running Foreman instance(and Smart Proxy) that has a clean database. A few things need to be added to Foreman to make the tests pass(NOTE: these will be added to seeds later) 
  - Any Operating System
  - A Host Group named `Test Host Group` that uses above Operating System
  - A Domain called `example.com` which is bound to above Host Group

4. A running phpIPAM instance that has a clean database. Ensure that `Prettify Links` is enabled, and there are no Sections listed.

_*IMPORTANT: These tests were designed to be run on clean databases for both Foreman and phpIPAM. Running these tests on instances that have data(aside from the objects listed above), will result in failed tests and potential data loss.*_

## Setup

1. `bundle install`
2. Copy `config/app-config.yml.example` to `config/app-config.yml` and provide Foreman and phpIPAM credentials
3. Ensure Foreman, Smart Proxy and phpIPAM are all up and running. NOTE: The Smart Proxy must have the smart_proxy_ipam plugin installed, and the `external_ipam` feature must be enabled.

## Running the Features

* To run all features: 
```
./run-tests.sh 
```
* To run a specific feature: 
```
cucumber features/phpipam/subnet.feature
```
There are cleanup features, run last, that will cleanup all test data used in Foreman and phpIPAM.

## Debugging

* To debug a specific step call save_and_open_page within the step

