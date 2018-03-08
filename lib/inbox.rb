require "inbox/engine"
require 'fileutils'
require 'pathname'

module Inbox
  class FileDelivery
    attr_reader :location

    def initialize(location)
      @location = location.freeze
    end

    def deliver!(mail)
      FileUtils.mkdir_p location
      location.join(filename = Time.now.to_f.to_s).open("w") do |f|
        f.write mail.encoded
      end
    end

    def deliveries
      location.each_child(false).map do |email_pathname|
        Mail.read( location.join(  email_pathname  ) )
      end
    end

    def clear
      location.each_child(false).map do |email_pathname|
        location.join(email_pathname).delete
      end
    end

    def settings
      {}
    end
  end

  ActionMailer::Base.add_delivery_method :inbox, Inbox::FileDelivery, Pathname.new("#{Dir.tmpdir}/mails")
end
