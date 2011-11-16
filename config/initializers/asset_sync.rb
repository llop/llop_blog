AssetSync.configure do |config|
  config.aws_access_key_id = 'AKIAIZEOTRJNBXMU4ONQ'
  config.aws_secret_access_key = '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'
  config.fog_provider = 'AWS'
  config.fog_directory = 'moleculardensity-assets'
  config.fog_region = 'eu-west-1'
  config.existing_remote_files = 'keep'
end