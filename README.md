
# Puppet-Notifier module



#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with notifier](#setup)
    * [Installation](#installation)
    * [Skyper](#skyper)
    * [Slacker](#slacker)
    * [Telegramer](#telegramer)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module allows you to send managed Puppet reports into Skype, Slack and Telegram about status changes on your infrastructure on every Puppet run. Reports would be sent for you if the status equals changed or failed.
Integration with PuppetBoard included!

## Setup

### Installation
It is *vital* to install this module into core modules folder of your Puppetserver (i.e /etc/puppetlabs/code/modules)!

### Skyper

1. Create the Skype bot at [BotFramework](https://dev.botframework.com/bots). Catch the Application ID and Application secret values.
2. Create conversation in Skype, add bot and write '/get name' in IM to gather chat ID.

### Slacker

You just need to add new webhook for your team [here](https://my.slack.com/services/new/incoming-webhook/). No additional modifications required.
Webhook would be in format https://hooks.slack.com/services/ABC/123/QWE

### Telegramer

1. Find the @BotFather contact
2. Write /newbot and pass through multiple questions.
3. Get the access token from the answer.
4. Add your new bot into channel and write something like @YOURBOT hello
5. Open https://api.telegram.org/bot<ACCESS_TOKEN>/getUpdates and find the chat id variable.

## Usage
Simply add the class of the service you want to use into your manifest:
```
$puppetboard_link = 'http://172.16.100.101/puppetboard/'
class { 'notifier::skyper':
  chat_id => 'somechatid@thread.skype',
  client_id => 'someclientid',
  puppetboard => $puppetboard_link,
  client_secret => 'someclientsecret'
}
class { 'notifier::slacker':
  hook_url => 'https://hooks.slack.com/services/ABC/123/QWE',
  username => 'Puppet Notifier',
  channel  => '#puppet-test',
  puppetboard => $puppetboard_link,
  icon_url => 'https://www.404techsupport.com/wp-content/uploads/2014/06/puppet-labs-featured.png'
}
class { 'notifier::telegramer':
  token => 'your_bot_token',
  chat_id => 'chat_id_from_api',
  send_stickers  => 'true',
  puppetboard => $puppetboard_link
}
```


## Reference

### notifier::skyper
####
chat_id - your conversation ID from '/get name' command
client_id -

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
