#!/usr/bin/env ruby
# encoding: utf-8
require 'puppet'
require 'yaml'
require 'telegram/bot'

if RbConfig::CONFIG['host_os'] =~ /freebsd|dragonfly/i
  TG_SETTINGS_FILE ||= '/usr/local/etc/puppet/telegramer.yaml'
else
  TG_SETTINGS_FILE ||= File.exist?('/etc/puppetlabs/puppet/telegramer.yaml') ? '/etc/puppetlabs/puppet/telegramer.yaml' : '/etc/puppet/telegramer.yaml'
end
TG_SETTINGS = YAML.load_file(TG_SETTINGS_FILE)

Puppet::Reports.register_report(:telegramer) do

  desc <<-DESC
  Send Puppet reports to Telegram.
  DESC

  def process
    if self.status == 'failed' or self.status == 'changed'
      Puppet.debug "Sending status for #{self.host} to Telegram."
      message = ''
      message << "Puppet run for *#{self.host}* in *#{self.environment}* has been finished with *#{self.status}* status\n"
      if TG_SETTINGS[:puppetboard_link]
        message << "[> Link to Puppetboard](#{TG_SETTINGS[:puppetboard_link]}/report/#{self.host}/#{self.configuration_version})"
      end

      Telegram::Bot::Client.run(TG_SETTINGS[:token]) do |bot|
        if TG_SETTINGS[:send_sticker]
          good_stickers = %w[CAADBAADXgADXSupAYuaA7Qvv6W7Ag
                             CAADBAADYAADXSupAWiaKbRZL688Ag
                             CAADBAAEAgAC4nLZAAE7R15Jpzl7cAI
                             CAADBAADHgIAAuJy2QAB-GEP4fhFPwcC]
          fail_stickers = %w[CAADBAADBAIAAuJy2QABw5aUAS4Z8j4C
                             CAADBAADyAEAAndCvAjDlzXHvA2GwQI
                             CAADAQADKQMAAj1jrQdxEtiXN_MXNAI]
          sticker_to_send = self.status == 'changed' ? good_stickers.sample : fail_stickers.sample
          bot.api.send_sticker(chat_id: TG_SETTINGS[:chat_id], sticker: sticker_to_send)
        end
        bot.api.send_message(chat_id: TG_SETTINGS[:chat_id], text: message, parse_mode: 'Markdown')
      end
    end
  rescue StandardError => e
    raise Puppet::Error, "Could not send report to Telegram ChatID #{TG_SETTINGS[:chat_id]} with token #{TG_SETTINGS[:token]}: #{e}\n#{e.backtrace}"
  end
end
