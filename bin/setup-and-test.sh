#!env zsh
# set -vx

das_setup() {
  # Setup runtime gems

  gem install excon -v 0.57.1
  gem install awesome_print -v 1.8.0
  gem install semantic_logger -v 4.1.1
  gem install terminal-table -v 1.8.0
  gem install thor -v 0.19.4

  # Setup dev gems

  gem install benchmark-ips -v 2.7.2
  gem install dry-struct -v 0.3.1
  gem install ffaker -v 2.6.0
  gem install flay -v 2.9.0
  gem install flog -v 4.6.1
  gem install license_finder -v 3.0.0
  gem install minitest-matchers -v 1.4.1
  gem install prolog_minitest_matchers -v 0.5.4
  gem install minitest-reporters -v 1.1.14
  gem install minitest-tagz -v 1.5.2
  gem install pry -v 0.10.4
  gem install pry-byebug -v 3.4.2
  gem install pry-doc -v 0.10.0
  gem install rake -v 12.0.0
  gem install reek -v 4.7.1
  gem install rubocop -v 0.49.1
  gem install ruby-prof -v 0.16.2
  gem install simplecov -v 0.14.1
  # gem install timerizer -v 0.1.4
  # gem install colorize -v 0.7.7
}

# Work around some recent fugliness in CodeShip
das_install() {
  if [[ $CI ]]; then
    bundle install
  else
    bundle install --local
  fi
}

if [[ $1 == 'setup' ]]; then
  das_setup
  das_install
  echo "To run tests, run $0 without the 'setup' argument."
  echo "Or just run 'bundle exec rake'"
else
  echo "./tmp/gemset" > .rbenv-gemsets
  echo "Current directory is `pwd`"
  bundle info rake
  bundle exec rake
fi

if [[ $ZSH_VERSION ]]; then
  unfunction `functions | egrep 'das_.* ()' | sed 's/ () {//'`
fi
echo 'All done'
