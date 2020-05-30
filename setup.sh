#!/usr/bin/env bash

declare -A config
config["client/cli"]="../../core/"

# Clone all repos that are not the workspace repo
curl -s "https://api.github.com/orgs/es-ex/repos?per_page=1000" \
| grep -o 'git@[^"]*' \
| grep -v workspace \
| xargs -L1 git clone 2>&1 | cat | sed 's/^fatal: d/D/'

# cd client/cli; npm link ../../core/; cd ../..
install () {
  if [ -f "package.json" ]; then
    npm install
    IFS=',' read -ra links <<< "${config[$1]}"
    for link in "${links[@]}"; do
      echo npm link "${link}"
    done
  else
    echo "Skipping installation as no package.json has been found in $project"
  fi
}

descent () {
  echo "Installing $1"
  IFS='-' read -ra array <<< "$1"
  if [[ ${#array[@]} -eq 2 ]]; then
    mkdir "${array[0]}"
    mv "$1/" "${array[0]}/${array[1]}"
    cd "${array[0]}/${array[1]}/" || exit 1
    install "${array[0]}/${array[1]}"
    cd ../..
  else
    install "$1"
  fi
  return 0
}

# Run npm install on every repo
for project in */ ; do
    descent "$(sed 's/\///' <<< $project)"
done