# NLopt Ruby

[NLopt](https://github.com/stevengj/nlopt) - nonlinear optimization - for Ruby

[![Build Status](https://github.com/ankane/nlopt-ruby/actions/workflows/build.yml/badge.svg)](https://github.com/ankane/nlopt-ruby/actions)

## Installation

First, install NLopt. For Homebrew, use:

```sh
brew install nlopt
```

And for Ubuntu 22.04+, use:

```sh
sudo apt-get install libnlopt0
```

Then add this line to your application’s Gemfile:

```ruby
gem "nlopt"
```

## Getting Started

Create an optimization

```ruby
opt = NLopt::Opt.new("LN_COBYLA", 2)
```

Set the objective function

```ruby
f = lambda do |x, grad|
  x[0] + x[1]
end
opt.set_min_objective(f)
```

Set constraints

```ruby
opt.set_lower_bounds([1, 2])
opt.set_upper_bounds([3, 4])
```

Perform the optimization

```ruby
xopt = opt.optimize([2, 3])
```

## History

View the [changelog](https://github.com/ankane/nlopt-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/nlopt-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/nlopt-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/nlopt-ruby.git
cd nlopt-ruby
bundle install
bundle exec rake test
```
