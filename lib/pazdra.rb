#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "rexml/document"
require 'open-uri'

class Pazdra

  GROUP_MAP = {
    0 => 'A',
    1 => 'B',
    2 => 'C',
    3 => 'D',
    4 => 'E',
    5 => 'A',
    6 => 'B',
    7 => 'C',
    8 => 'D',
    9 => 'E',
  }

  def initialize(id)
    @id = id
  end

  def group
    key = @id.to_s[2]
    if key
      GROUP_MAP[key.to_i]
    end
  end

  def guerrillas
    doc = REXML::Document.new raw_xml
    guerrillas = {}
    doc.elements.each('/root/item') do |element|
      hours = element.get_text('hour').to_s.split('&lt;br&gt;')
      guerrillas[element.get_text('group').to_s] = {
        :day => element.get_text('day').to_s,
        :type => element.get_text('type').to_s,
        :hours => hours
      }
    end
    guerrillas
  end

  def guerrilla
    guerrilla = guerrillas[group]
    now = Date.today.strftime("%m/%d")
    guerrilla if guerrilla[:day] == now
  end

  def raw_xml
    open('http://pad.zap.jp.net/time.xml').read
  end
end
