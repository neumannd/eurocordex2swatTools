#!/bin/bash

for iFile in `ls man/*.Rd | sed 's#man/##g' | sed 's/\.Rd//g'`; do
 echo "Processing file ${iFile}.Rd"
 R CMD Rdconv --type=html man/${iFile}.Rd > html/${iFile}.html
done
