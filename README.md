# TRMNL Plugin Development Kit

A plugin development kit for TRMNL devices.

Developing private plugins can be a difficult task where you're creating 4 different layouts.
Editing on the [TRMNL website](https://usetrmnl.com) is helpful, but I find it hard to work with the layout provided and to change the data you're using in the template.
This development kit allows you to view your four layouts easily and to provide various versions of the data used in the template without having to get the data onto TRMNL's servers.

## Setup

I prefer to use [`rbenv`](https://github.com/rbenv/rbenv) for managing Ruby versions, but you're welcome to use a locally installed version.
If you do choose to install `rbenv`, you might get caught out if you don't immediately run `rbenv init`, follow its instructions and then restart your terminal.
Note that the version of Ruby I've used is in the `.ruby-version` file and `rbenv` will use that file to determine which version to install.
Ensure you run these commands from the root of this tool's checked out code:

```shell
rbenv install
```

Once you have a valid version of Ruby installed, you need to use Bundler to install the required gems:

```shell
bundle install
```

That's all the setup!
To run the application, use the following command:

```shell
bundle exec ruby trmnl-plugin-dev-kit.rb
```

The web app will be running on [http://localhost:4567](http://localhost:4567).

## Usage

Usage instructions.
