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
      puts "nokogiri passed"
      image = ImageCreator.image_from_url(url)
      puts "image created"

      if image && doc

        resource = WebResource.new(
            url:url,
            image:image,
            html_original:doc.to_s,
            title:doc.title
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
    url = url.strip
    if !(url =~ /^(http):\/\//)

      return "http://#{url}"

    end

    return url

  end

end
