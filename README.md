"Its" makes testing methods with multiple arguments much easier
==================================================


![Build Status](https://secure.travis-ci.org/dnagir/its.png)


Have you ever written something like this in your specs?

```ruby
it "should be US currency" do
  subject.currency(:us).should == 'US dollar'
end

it "should be AU currency" do
  subject.currency(:us).should == 'AU dollar'
end

it "should be UK currency" do
  subject.currency(:uk).should == 'UK pound'
end
```

If yes, then this is what you really needed:

```ruby
its(:currency, :us) { should == 'US dollar' }
its(:currency, :au) { should == 'AU dollar' }
its(:currency, :uk) { should == 'UK pound' }
```

Installation and use
==================================================

Add to your `Gemfile`:

```ruby
gem 'its'
```

Then require it somewhere:

```ruby
require 'its'
```

And you are done.


Help
==================================================

Please report any issues here or better submit a Pull Request.



License:
==================================================

MIT by me and RSpec guys where this code was extracted from.
