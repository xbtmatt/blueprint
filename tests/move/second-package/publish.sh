#!/bin/bash
aptos move publish --named-addresses second_package=local3,wrapper_consumer=local3,wrapper=local2,arguments=local --profile local3 --skip-fetch-latest-git-deps

