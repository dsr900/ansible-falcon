#!/bin/bash

git clone https://github.com/cdunn2001/git-sym.git
git clone https://github.com/pb-cdunn/FALCON-examples.git
cd FALCON-examples
../git-sym/git-sym update run/greg200k-sv2
mv run/greg200k-sv2/data/greg200k-sv2/subreads* project_dir
rm -rf FALCON-examples/ git-sym/
