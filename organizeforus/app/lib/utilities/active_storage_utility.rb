class ActiveStorageUtils
    def self.image_url(image, size=nil)
      url_for(image, size)
    end
  
    def self.file_url(file)
      url_for(file)
    end
  
    private
  
    def self.url_for(file, size=nil)
      return unless file && file.attached?
      url_helpers = Rails.application.routes.url_helpers
      
      if size && file.variable?
        url_helpers.rails_representation_url(file.variant(resize_to_fill: size).processed, only_path: true)
      else
        url_helpers.rails_blob_path(file, only_path: true)
      end
      rescue StandardError => error
        Log.error(error)
        nil
    end
  end