#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require File.expand_path("../../lib/pazdra.rb", __FILE__)
require 'pit'
require 'im-kayac'

if __FILE__ == $PROGRAM_NAME
  im_kayac_conf = Pit.get('im.kayac.com', :require => {
                            "username" => "your im.kayac user name",
                            "password" => "your im.kayac password"
                          })

  pazdra_conf = Pit.get('pazdra', :require => {
                          "id" => "your パズドラ id"
                        })
  pazdra = Pazdra.new(pazdra_conf["id"])
  guerrilla = pazdra.guerrilla
  hour = Time.now.hour

  if guerrilla[:hours].include?(hour.to_s)
    text = "【パスドラ】ゲリライベント #{guerrilla[:type]}"
    ImKayac.post(im_kayac_conf["username"], text, {
                   :password => im_kayac_conf["password"],
                   :handler => "http://pad.zap.jp.net/"
                 })
  end
end
