# require 'carrierwave/processing/rmagick'

class PhotoUploader < CarrierWave::Uploader::Base

  ##
  # Storage type
  #
  storage :file

end
