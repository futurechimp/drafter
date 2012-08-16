# require 'carrierwave/processing/rmagick'

class Uploader < CarrierWave::Uploader::Base

  ##
  # Storage type
  #
  storage :file

end
