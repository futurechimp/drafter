# This CarrierWave uploader is used to steal incoming files off of
# draftable objects, and store them on a DraftUpload for later use.
#
class DraftUploader < CarrierWave::Uploader::Base

  storage :file

  ##
  # Directory where uploaded files will be stored (default is /public/uploads)
  #
  def store_dir
    "system/draft_uploads/#{model.to_param}"
  end

  ##
  # Directory where uploaded temp files will be stored (default is [root]/tmp)
  #
  def cache_dir
    "system/draft_uploads/tmp"
  end

end