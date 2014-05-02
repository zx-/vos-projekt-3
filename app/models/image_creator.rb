class ImageCreator

  def self.image_from_url(url)

    url = url.gsub(/^http:\/\//,'')

    if url !="" && system("cutycapt --url=#{url} --out=app/assets/images/#{url}.png")

      return "#{url}.png"

    end

    return nil

  end

end