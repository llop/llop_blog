Sprockets::StaticCompiler.class_eval do
  def compile
    manifest = {}
    env.each_logical_path do |logical_path|
      STDERR.puts ('trying ' + logical_path.to_s)
      next unless compile_path?(logical_path)
      if asset = env.find_asset(logical_path)
        manifest[logical_path] = write_asset(asset)
      end
    end
    write_manifest(manifest) if @manifest
  end
  def write_asset(asset)
    path_for(asset).tap do |path|
      STDERR.puts ('doing ' + path.to_s)
      filename = File.join(target, path)
      FileUtils.mkdir_p File.dirname(filename)
      asset.write_to(filename)
      asset.write_to("#{filename}.gz") if filename.to_s =~ /\.(css|js)$/
    end
  end
end