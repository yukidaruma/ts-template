#!/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/yukidaruma/ts-template/main/RUN_ME.sh)

set -e

template_repo='https://github.com/yukidaruma/ts-template'

printf "What is new project name?\n> "
read -r project_name

! [[ $project_name =~ ^[-a-z0-9]+$ ]] && echo "Invalid project name. Quitting." && exit 1

git clone --depth=1 "$template_repo.git" "$project_name"
cd "$project_name"
rm -rf .git
rm -f RUN_ME.sh
git -c init.defaultBranch=main init
git commit --allow-empty -m "Initial commit"

sed -i -e "s/project_name/$project_name/g" package.json package-lock.json
sed -i -e "s/<project_name>/$project_name/g" README.md
# Remove lines after pattern and replace multiple '\n's at EOF with single '\n'
sed -e '/<!-- END_OF_CONTENT -->/,$d' README.md | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > tmpfile && mv tmpfile README.md
git add .
git commit -m "Create new TypeScript project using $template_repo"

npm install
