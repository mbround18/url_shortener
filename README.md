# url_short (Alpha Release)

## Currently Supported Distrobutions

 1. Ubuntu 16.04 Xenial

## Install Process:
When installing please install under a service account (EX: Jenkins)

### Packages: 
```sh
$ apt-get install gcc autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev postgresql postgresql-server-dev-all
```

### Database Requirements:
Creating the user and database...
```sh
$ sudo -u postgres createuser --encrypted --pwprompt urlshorty
$ sudo -u postgres createdb urlshorty
```

Granting the user permissions...
```sh
$ sudo -u postgres psql
psql=# grant all privileges on database urlshorty to urlshorty ;
```


[Source](https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e)

### Ruby Recommended Install:
[Install: rbenv](https://github.com/rbenv/rbenv)
[Install: rbenv-build](https://github.com/rbenv/ruby-build)

```sh
rbenv install 2.4.2
rbenv shell 2.4.2
gem update
gem update --system
gem install bundler
```

### Installing the Repo:
```sh
git clone https://github.com/mbround18/url_shortener.git
cd ./url_shortener

bundle --binstubs
cp ./config-sample.json ./config.json
nano ./config.json #edit the config.json as neccessary with the database connection info that you used above

bundle exec rake ar:migrate
bundle exec rake ar:seed
```
