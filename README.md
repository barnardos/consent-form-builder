# consent-form-builder

The purpose of the consent form generator is to allow a Barnardos researcher to
enter details about an upcoming research session and produce consent forms that can
initially be paper signed by a participant, and later be digitally signed.

## Getting started

Install:

* [Bundler](http://bundler.io/)
* [Hivemind](https://github.com/DarthSim/hivemind)
* [Node](https://nodejs.org/en/)
* [PostgreSQL](https://www.postgresql.org/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Yarn](https://yarnpkg.com)

Run these commands:

* `bundle install` - install all Ruby dependencies.
* `yarn` - install all Javascript dependencies.
* Set up the Postgres database.
  * To access postgres from terminal, type the command `psql postgres`.
  * Add a user named 'consent' to your postgres instance.
    * `CREATE USER consent;`
  * Add a database named 'consent' to your postgres instance, and make 'consent' the owner.
    * `CREATE DATABASE consent OWNER consent;`
  * Add a database named 'consent_test' to your postgres instance, and make 'consent' the owner.
    * `CREATE DATABASE consent_test OWNER consent;`
* `bundle exec rails db:migrate` - update the database schema.
* `hivemind Procfile.dev` - start a development server.

* If you have issues building your test database (`consent_test`), upgrade user to a SUPERUSER, access PostgreSQL in your terminal (`psql postgres`), then `ALTER USER consent WITH SUPERUSER;`. To check user attributes `\du`. Quit `\q`

### Testing

Run test suite: `bundle exec rake`

## Release Guide - How to deploy changes to Live

### CHANGELOG.md

Its [format](https://github.com/tech-angels/vandamme#format) is as per the recommendations in the
[vandamme](https://github.com/tech-angels/vandamme) gem. Released versions come under headings with
their version number, e.g:

```
# 0.1.0 / 2017-09-19

* [FIX] Margin problem when scrolling the header on mobile
* [FEATURE] Allow users to return to the research session with a bookmark
```

Once released, these sections should be seen as immutable.

As we develop, we continually update an `Unreleased` version at the top of the file:

```
# 0.2.0 / Unreleased

* [FIX] bug #2
* [FEATURE] experimental unicorn
```

We add a line to this file every time a PR is merged and in review on staging. If the merged
PR is reverted due to the rare case of failing review on staging, the line must be removed
as part of the commit reverting the changes. Note the disappearance of the experimental unicorn:

```
# 0.2.0 / Unreleased

* [FIX] bug #2
```

During deployment, and at the same time as tagging, this word `Unreleased` will be
replaced with the ISO8601 (YYYY-MM-DD) date of release.

### Process

1.  Create a new release branch from master

```
git checkout -b release-0.2.0 master
```

2.  In the CHANGELOG.md file, replace latest 'Unreleased' entry to be date of release

```
# 0.2.0 / 2017-10-04
```

3.  Commit this change and push to release branch

```
git add CHANGELOG.md
git commit -m "Release 0.2.0"
git push -u origin release-0.2.0
```

4.  Create Pull Request (PR)

![Create PR](public/release-pr.png)

It's ok to merge this PR with a cursory review. You may need to wait for a build.

5.  Once PR has been merged, tag the release of master we're deploying from (usually HEAD)

Go back to the `master` branch:

```
git checkout master
git pull
git tag v0.2.0
git push --tags
```

6.  Promote the Heroku release from staging to production

**NB** Ensure the latest commit has been auto-deployed to staging before
promoting. If you don't, it's likely you'll deploy all the changes but not the
CHANGELOG.md commits, which will result in all the behaviour being present but the
wrong SHA showing on production.

From the Heroku pipeline for the app, [promote](https://devcenter.heroku.com/articles/pipelines#promoting)
the release, either from the web UI:

![Promote from staging](public/promote.png)

... or alternatively, from the command line, which requires that you have a `git remote` for the staging application. Normally, that would match the `heroku` repo (if you have one of those). In this example, we added a remote with `git remote add consent-form-builder-stage https://git.heroku.com/consent-form-builder-stage.git`:

```
heroku pipelines:promote -r consent-form-builder-stage
Promoting consent-form-builder-stage to example (production)... done, v23
Promoting consent-form-builder-stage to example-admin (production)... done, v54
```
