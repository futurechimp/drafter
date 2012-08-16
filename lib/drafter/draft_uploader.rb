# This CarrierWave uploader is used to steal incoming files off of
# draftable objects, and store them on a DraftUpload for later use.
#
class DraftUploader < CarrierWave::Uploader::Base

  storage :file

end