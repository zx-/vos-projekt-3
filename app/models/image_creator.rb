class ImageCreator

  def self.image_from_url(url)

    result = system("cutycapt --url=#{url} --out=tmp/#{url}.png")
    if result

      

    end

  end

end