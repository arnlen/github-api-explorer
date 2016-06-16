# GitHub API Explorer [![Build Status](https://travis-ci.org/arnlen/github-api-explorer.svg?branch=master)](https://travis-ci.org/arnlen/github-api-explorer) [![Code Climate](https://codeclimate.com/github/arnlen/github-api-explorer/badges/gpa.svg)](https://codeclimate.com/github/arnlen/github-api-explorer) [![Test Coverage](https://codeclimate.com/github/arnlen/github-api-explorer/badges/coverage.svg)](https://codeclimate.com/github/arnlen/github-api-explorer/coverage)

Search an user on the GitHub API and store the results locally.

## Usage

1. On the home page, enter a GitHub username in the search field.
2. Look at the data. Those data are fetched from GitHub, and stored locally.
3. You can consult the stored data on the "Users" page.
4. To refresh an user, simply search it again from the home page.

Easy. :)

## Live demo

The master branch of this repository is automagically deployed to Heroku when Travis is green.

You can test it here: [github-api-explorer.herokuapp.com](https://github-api-explorer.herokuapp.com/)

![](http://i.memecaptain.com/gend_images/jevOcA.gif)

## Requirements

- [Bundler](http://bundler.io/)
- [PostgreSQL](https://www.postgresql.org/download/)

## Getting started

```
git clone git@github.com:arnlen/github-api-explorer.git
bundle
bin/rake db:create
bin/rake db:migrate
bin/rake db:test:prepare
rails s

# => visit localhost:3000 and enjoy!
```

## Caution: Rails 5 project

This project relies on Rails 5.0.0.rc1. Please ensure your system complies with [Rails 5 requirements](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-4-2-to-rails-5-0).

Since Rails 5 is - sadly - not yet released, this project can't be considered as production ready.