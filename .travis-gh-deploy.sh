if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
  echo "Deploying to GitHub pages"
  mkdir gh_pages
  cd gh_pages
  git init
  git config user.name "nixos-guides-travis-build"
  git config user.email "maarten@moretea.nl"
  git remote add origin "https://$GH_TOKEN@github.com/moretea/nix-guides"
  git fetch
  git reset origin/gh-pages
  cp -r ../result/* .
  git add -A .
  git commit -m "Rebuild pages from $TRAVIS_COMMIT"
  git push -q origin HEAD:gh-pages
fi
