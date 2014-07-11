#! /usr/bin/env ruby
require 'io/console'

class SQRT
  CONTRIBUTORS = [
    {
      year: 2014,
      name: "Sam Hon",
      url:  "@kopisam"
    }
  ]

  def initialize(args)
    @text = args[0]
    @file = args[1]
    @auto = args.include?("--auto")
    @mute = args.include?("--quiet")
    self
  end

  def credits
    SQRT::CONTRIBUTORS.each do |dev|
      log "(C) #{dev[:year]} #{dev[:name]} #{dev[:url]}\n\n"
    end
  end

  def banner
    log "\n"
    log "Simple QR Toolkit"
    credits
    log "Converting text  : #{@text}"
    log "Destination file : #{@file}_qr.png"
    log "\n"
  end

  def log(message)
    puts message unless @mute
  end

  def proceed?
    unless @auto
      print "Are you sure? [y/n] "
      input = STDIN.getch
      log "\n\n"
    end
    @auto || input.match(/y/i)
  end

  def to_qrcode
    banner
    if proceed?
      code = @text.gsub(" ", "+")
      `curl --silent -d "cht=qr&chs=64x64&chl=#{code}&chld=L|0" "http://chart.apis.google.com/chart" > "#{@file}_qr.png"`
      `open #{@file}_qr.png` unless @mute
    else
      log "QR Code generation aborted!\n"
    end
  end
end

SQRT.new(ARGV).to_qrcode