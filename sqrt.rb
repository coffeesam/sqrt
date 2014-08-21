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
    @text = args[0].upcase
    @file = args[1] || "./output/#{@text.downcase.gsub(/-|\s/, '_')}_qr.png"
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
    show_usage if empty_args?
  end

  def show_usage
    log "usage: ./sqrt text outpath [--auto] [--quiet]"
    log "\n\n"
    log "  text      : text to encode in QR code"
    log "  output    : output path to write PNG image to"
    log "\n\n"
    log "  OPTIONS"
    log "    --auto  : proceed to generate QR code without prompt"
    log "    --quiet : suppress sending messages to stdout"
    log "\n\n"
  end

  def log(message)
    puts message unless @mute
  end

  def empty_args?
    @text.nil?
  end

  def proceed?
    unless empty_args?
      log "Converting text  : #{@text}"
      log "Destination file : #{@file}"
      log "\n"
      unless @auto
        print "Are you sure? [y/n] "
        input = STDIN.getch
        log "\n\n"
      end
      @auto || input.match(/y/i)
    end
  end

  def to_qrcode
    banner

    if proceed?
      code = @text.gsub(" ", "+")
      correction_level = if code.size < 19
        "H"
      elsif code.size < 38
        "M"
      else
        "L"
      end
      `curl --silent -d "cht=qr&chs=64x64&chl=#{code}&chld=#{correction_level}|0" "http://chart.apis.google.com/chart" > "#{@file}"`
      `open "#{@file}"` unless @mute
    else
      #log "QR Code generation aborted!\n"
    end
  end
end

SQRT.new(ARGV).to_qrcode