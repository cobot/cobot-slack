[![Build Status](https://travis-ci.org/cobot/cobot-slack.svg?branch=master)](https://travis-ci.org/cobot/cobot-slack)

This app automatically invites members of a space on Cobot to a Slack.com team. To see it in action, go to http://slack.apps.cobot.me.

## About

This is a Ruby on Rails app that provides the following:

* landing page (`app/views/welcome/show.html.erb`)
* log in via Cobot OAuth (`app/controllers/sessions\_controller.rb` + omniauth gem)
* set up an integration between a Cobot space and a Slack team (`app/controllers/teams_controller.rb`)
  * set up webhooks on Cobot (`TeamsController#set_up_webhooks`) for new members
  * listen to webhooks (`app/controllers/membership_confirmations_controller.rb#create`)
  * call Slack API to send invites (`app/services/team_service.rb`)

## Setup

* create OAuth client on Cobot (for scopes, see `config/initializers/omniauth.rb`)
* add ENV vars (see `config/secrets.yml`)

## License

The source code of this app is licensed under MIT license. The contents of the cobot_assets gem (vendor/cache/cobot_assets) remain proprietary.
