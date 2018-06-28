# Prolenea

## Installation

```bash
$ gem install prolenea
```

## Usage

### CLI Usage

```bash
$ prolenea-client -u http://prolenea.example.com -n 12125551000
```

### Ruby Usage

```ruby
require 'prolenea'

options = {}
options[:uri] = 'http://prolenea.example.com'
number = '12125551000'

Prolenea.connect options

result = Prolenea.lookup_number number

puts JSON.pretty_generate result
```

### Output

```javascript
{
  "number": "2125551000",
  "local_routing_number": "6465550000",
  "ported_date": "2015-07-09T15:00:00-05:00",
  "alternative_spid": null,
  "alternative_spid_name": null,
  "line_type": null,
  "operating_company_number": "MULT",
  "operating_company_name": "MULTIPLE OCN LISTING",
  "lata": "99999",
  "city": "CUSTOMER DIRECTORY ASSISTANCE",
  "state": "NY"
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klarrimore/prolenea.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
