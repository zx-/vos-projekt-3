class PageParser
  require 'uri'

  # href zahodit, url,src zmenit
  def self.parse! doc,domain_name

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

    if domain_name.to_s.match /youtube/

      #<meta name="twitter:player" content="url">
      if el = doc.search('meta[name="twitter:player"]')[0]

        return "<iframe width='95%' height='95%' src='#{el.attr('content')}' frameborder='0' allowfullscreen></iframe>"

      end

    end

    doc.to_s

  end

  def self.get_image doc

    search = {

        'meta[property="og:image"]' => 'content',
        'link[rel="apple-touch-icon-precomposed"]' => 'href',
        'link[rel="apple-touch-icon"]' => 'href',
        'link[rel="icon"]' => 'href',
        'link[rel="shortcut icon"]' => 'href'

    }



    search.each do |s,at|

      elems = doc.search(s)

      puts elems.inspect

      if elems.last

        return elems.last.attr at

      end


    end

    return nil


  end

  #private

  def self.change_url url,domain

    domain = "http://"+domain


    if (url.to_s.match /^\w.*/) && !(url.to_s.match /^(http(s)?):\/\// ) && !(url.to_s.match /^www\..*/)

      return domain+"/"+url.to_s

    end

    if url.to_s.match /^\..*/

      return domain+"/"+url.to_s.slice!(0)

    end

    if url.to_s.match /^\/[^\/]+/

      return domain+url.to_s

    end

    return url.to_s

  end

end