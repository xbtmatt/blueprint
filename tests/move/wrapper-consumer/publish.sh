#!/bin/bash
aptos move publish --named-addresses wrapper_consumer=local3,wrapper=local2,arguments=local --profile local3 --skip-fetch-latest-git-deps --assume-yes

