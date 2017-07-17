<h1>DoApiScripting</h1>

- [DoApiScripting](#doapiscripting)
  * [Installation](#installation)
  * [Usage](#usage)
  	  * [Help](#help)
  	  * [All Droplets](#all-droplets)
  	  * [All Floating IPs](#all-floating-ips)
  	  * [Assign Floating IP](#assign-floating-ip)
  	  * [Droplet Info](#droplet-info)
  	  * [Power Off](#power-off)
  	  * [Power On](#power-on)
  	  * [Rename](#rename)
  	  * [Shutdown](#shutdown)
  	  * [Version](#version)
  * [Development](#development)
  * [Contributing](#contributing)
    * [Contributing](#contributing)
      * [Process](#process)
      * [Notes on Contributing](#notes-on-contributing)
  * [License](#license)

## Overview

This Gem provides an executable (`do_api`) which exposes commands to exercise several command and query actions in the [DigitalOcean API v2](https://developers.digitalocean.com/documentation/v2/). These are useful, for example, as part of an [Ansible](https://www.ansible.com/) setup to deploy to and manage one or more DO Droplets and/or Floating IPs.

## Installation

This Gem is not anticipated to normally be used as a component within another Ruby project, but rather to provide a standalone executable that you can use to help manage your DigitalOcean Droplets. Install it as you would any other "tool"-type Gem, by running

    $ gem install do_api_scripting

from the command line.

## Usage

See the [Usage Specification](./doc/USAGE-SPECIFICATION.md), documented separately.

## Development

After checking out the repo, run `bin/setup` to install dependencies. This will use [`rbenv` Gemsets](https://github.com/jf/rbenv-gemset) to install all needed gems into `tmp/gemset` and then bundle locally, keeping your system Gem repository pristine. **NOTE** that this therefore assumes that you are actually using `rbenv` and have the `rbenv-gemset` plugin installed; if you're using `rvm` or some other Ruby Gem manager, you'll need to make appropriate changes to `bin/setup-and-test.sh` and `bin/setup`.

Then, run `bin/rake test` to run the tests, or `bin/rake` to run tests and, if tests are successful, further static-analysis tools ([RuboCop](https://github.com/bbatsov/rubocop), [Flay](https://github.com/seattlerb/flay), [Flog](https://github.com/seattlerb/flog), and [Reek](https://github.com/troessner/reek)).

To install *your build* of this Gem onto your local machine, run `bin/rake install`. We recommend that you uninstall any previously-installed "official" Gem to increase your confidence that your tests are running against your build.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jdickey/do_api_scripting](https://github.com/jdickey/do_api_scripting). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Process

If you wish to submit a new feature to the Gem, please [open an issue](https://github.com/jdickey/do_api_scripting/issues/new) to discuss your idea with the maintainer and other interested community members. Issue threads are a great place to thrash out the details of what you're trying to accomplish and how your work would affect other code and/or community members. If you need help with something, or aren't sure how to choose between different ideas to accomplish some detail of what you're setting out to do, this is the place to discuss that. There is *no such thing as a stupid question that you don't know the answer to* (once you've researched in your search engine of choice, of course; please do respect people's time and attention).

The processes for proposing a new feature or a fix to an open bug-report issue are very similar:

1. Make sure that you have forked this Gem's [repository on GitHub](https://github.com/jdickey/do_api_scripting) to your own GitHub account. (If you don't yet have a GitHub account, [join](https://github.com/join?source=header-home); it's free.)
2. If you're proposing a new feature, [open an issue](https://github.com/jdickey/do_api_scripting/issues/new) as suggested above. If you're addressing an existing issue, *thanks;* you don't need to open a new one.
3. Clone *your* copy of the repo to your local development system.
4. Create a new Git branch for your work. It's best to give it a reasonably short name that's suggestive of what you're specifically trying to accomplish.
   1. If you're adding a new feature that you've already described in an issue, name the branch something like `add-droplet-resize-command-NNN`, where `NNN` is the issue number of the feature-proposal issue that you've opened;
   2. If you're adding a fix for an existing issue, say a hypothetical Issue #41 related to updating a Droplet's firewall, then a branch name of `update-droplet-firewall-41` is probably perfect.
   3. **Do not** work on your copy of the `master` branch! Any pull request (see below) that you later submit for changes you've made on `master` will be rejected, and you will be asked to submit your proposed changes on a branch that branches from a commit on the upstream `master` branch.
5. Now write great (tests and) code!
6. As soon as you have something to show, *even if it's not complete yet* (but it passes what tests you have, as well as static-analysis checks), [push your branch](https://help.github.com/articles/pushing-to-a-remote/) to *your forked repo* on GitHub and open a [new pull request](https://github.com/jdickey/do_api_scripting/compare) ("PR") for *your branch* compared to `master` on the [upstream](https://github.com/jdickey/do_api_scripting/) repository. That lets the maintainer and other community members review your code and tests, comment, help out, and so on.
7. Continuing with your pull requests, it's usually better if you make small, incremental changes in each commit in a sequence. We (endeavour to) practice [behaviour-driven development](https://en.wikipedia.org/wiki/Behavior-driven_development): write tests for the simplest thing that could possibly work; see the tests fail; then make them pass, commit, and go on to the next simplest thing. Don't get hung up on lots of refactoring until you have code that does everything you want it to do; once you have a legitimately complete green bar, *that's* the time to apply SOLID principles and patterns to DRY things up. Better to have (temporary) duplication than choose the wrong abstraction.
8. Once your PR is approved for merging, it will be [squashed and merged](https://help.github.com/articles/about-pull-request-merges/#squash-and-merge-your-pull-request-commits), appearing as a single commit on `master`. Note that this isn't as "friendly" as rebasing, but this maintainer is not aware of any "squash and rebase" capability in Git. (If you are aware of how to do that, *please* open an issue and tell us all about it). Having new features, bug fixes, and so on, appear in `master` as a single commit makes reading the `master` log much more coherent; we presently *do not* delete merged branches (though you may wish to in your forks).

### Notes on Contributing

Don't be discouraged if it takes several commits to complete your work and then several more to get everybody agreeing that it's complete and well done. ("Useful" and "worth adding" should have been settled at the issue stage, before you started working on your PR.) That's because&hellip;

When pull requests are *merged* into the `master` branch, they are *squashed* so that all changes are applied to `master` in a single commit. This means that, even if you have a dozen or more commits in your PR where you've been *very* incremental, and even changed direction once or twice, what matters is the final result; not what it took to get there.

Once your PR has been merged, it's a good idea to pull the upstream `master` branch to your development system (`git pull upstream master`) and then push it to your fork (`git push origin master`). (What? You don't *have* an `upstream` remote as shown by `git remote -v`? Run the command `git remote add upstream https://github.com/jdickey/do_api_scripting.git` from your local development directory, and now you do.)

## License

The Gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
