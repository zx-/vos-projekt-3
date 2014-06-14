class PageParser
  require 'uri'

  # href zahodit, url,src zmenit
  def self.parse! doc,domain_name

    puts "################################3"
    puts "parsujeme web"


    meta_node = Nokogiri::XML::Node.new('meta',doc)
    meta_node.set_attribute('charset', 'UTF-8')
    head = doc.at_css "head"
    head.children.first.add_previous_sibling(meta_node)

    doc.traverse do |node|

      if node.has_attribute?('url')

        node.set_attribute 'url', change_url(node.attribute('url'),domain_name)

      elsif node.has_attribute?('href')

      if node.name == "a"
        node.set_attribute 'href', 'javascript: void(0)'
      else
        node.set_attribute 'href', change_url(node.attribute('href'),domain_name)
      end

      elsif node.has_attribute?('src')

        node.set_attribute 'src', change_url(node.attribute('src'),domain_name)

      end

      if node.name == "input"
        node.set_attribute('disabled','disabled')
      end

    end

    puts " FINISHED"
    puts "################################3"

    doc

  end

  #private

  def self.change_url url,domain

    domain = "http://"+domain

    puts "change #{url} with #{domain}"

    if (url.to_s.match /^\w.*/) && !(url.to_s.match /^(http(s)?):\/\// ) && !(url.to_s.match /^www\..*/)

      puts "to "+domain+"/"+url
      return domain+"/"+url.to_s

    end

    if url.to_s.match /^\..*/

      puts "to "+domain+"/"+url
      return domain+"/"+url.to_s.slice!(0)

    end

    if url.to_s.match /^\/[^\/]+/

      puts "to "+domain+url
      return domain+url.to_s

    end

    puts "to #{url}"
    return url.to_s

  end

end