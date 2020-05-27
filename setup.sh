#! /bin/bash

# Clone all repos that are not the workspace repo
curl -s "https://api.github.com/orgs/es-ex/repos?per_page=1000" \
| grep -o 'git@[^"]*' \
| grep -v workspace \
| xargs -L1 git clone 2>&1 | cat | sed 's/^fatal: d/D/'

# Run npm install on every repo
for project in */ ; do
    pushd $project > /dev/null
    if [ -f "package.json" ]; then
      npm install
    else
      echo "Skipping installation as no package.json has been found in $project"
    fi
    popd > /dev/null
done
