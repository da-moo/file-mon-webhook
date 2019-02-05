# file-mon-webhook

## What this Is

A personal file monitoring script written in ruby using the
[discordrb-webhooks](https://github.com/meew0/discordrb/tree/master/lib/discordrb/webhooks) gem to post to
[Discord](https://discordapp.com/) webhook URLs.

## What this Isn't

Robust enough to be considered "production ready". While it's been perfectly fine for my personal use, I am not
responsible if you deploy this and it causes undesirable results.

## Features

- Monitors an arbitrary number of directories with a file-based config
- Supports regex-based ignore patterns
- Configurable polling latency for filesystems than need it (such as network shares)

## Running the Script

1. `bundle install`
2. Create and fill out a `config.rb` in the `config` directory, following `example.config.rb` as a guide.
3. Run `bundle exec ruby webhook.rb`

## Contributing

Pull requests, constructive criticism, and recommendations welcome. We're all learners here.

## License

This project is available as open source under the terms of the [MIT license](https://opensource.org/licenses/MIT). See
`LICENSE.txt` in the project root directory for details.

