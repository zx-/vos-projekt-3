class WebResource < ActiveRecord::Base

  require 'open-uri'
  require 'uri'

  has_many :chat_room_web_resources
  has_many :chat_rooms, :through => :chat_room_web_resources

  def get_image_url

    if !self.image.nil?

      return self.image

    else

      ActionController::Base.helpers.asset_path("default.jpg")

    end

  end

  def self.add_url_resource (in_url)

    false unless check_url in_url

    url = clean_url(in_url)
    res = WebResource.find_by_url(url)
    resource = nil
    return res if res

    begin

      doc = Nokogiri::HTML(open(url))
      puts "nokogiri passed"
      #image = ImageCreator.image_from_url(url)
      original_html = doc.to_s

      if doc

        puts "domain name:"
        puts get_domain_name(url)
        edited_doc_string = PageParser::parse! doc,get_domain_name(url)
        begin

          image = PageParser::get_image doc

        rescue

          puts "image Failed"
          image = nil

        end

        resource = WebResource.new(
            url:url,
            image:image,
            html_original:original_html.encode('UTF-8'),
            html_edited: edited_doc_string.encode('UTF-8'),
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

  def self.get_domain_name url

    URI.parse(url).host

  end

  def self.check_url (url)
    !!URI.parse(url)
    rescue URI::InvalidURIError
      false
  end

  def self.clean_url (url)
    url = url.strip
    if !(url =~ /^(http(s)?):\/\// )

      return "http://#{url}"

    end

    return url

  end

end
