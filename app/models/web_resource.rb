class WebResource < ActiveRecord::Base

  require 'open-uri'

  has_many :chat_room_web_resources
  has_many :chat_rooms, :through => :chat_room_web_resources

  def self.add_url_resource (in_url)

    url = clean_url(in_url)
    res = WebResource.find_by_url(url)
    resource = nil
    return res if res

    begin

      doc = Nokogiri::HTML(open(url))
      image = ImageCreator.image_from_url(url)

      if image && doc

        resource = WebResource.new(
            url:url,
            image:image,
            html_original:doc.to_s
        )

        resource.save

      end

    rescue

      puts "Error #{$!}"
      return nil

    end

    return resource

    end

  private

  def self.clean_url (url)

    if !(url =~ /^(http):\/\//)

      return "http://#{url}"

    end

    return url

  end

end
