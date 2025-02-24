#!/bin/bash
cd arguments && ./publish.sh && 
cd ../wrapper && ./publish.sh && 
cd ../wrapper-consumer && ./publish.sh
cd ../second-package && ./publish.sh


