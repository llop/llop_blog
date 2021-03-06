Sprockets::Helpers::RailsHelper::AssetPaths.class_eval do
  def digest_for(logical_path)
    if digest_assets && asset_digests && (digest = asset_digests[logical_path])
      return digest
    end
    if compile_assets && digest_assets && asset = asset_environment[logical_path]
      return asset.digest_path
    end
    return logical_path  # Just return the freakin path! Why explode?!
  end
end