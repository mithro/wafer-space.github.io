# Test only (wafer-space/wafer-space.github.io#80): shows that a fork PR's
# plugins run in the preview build.
Jekyll::Hooks.register :site, :post_write do |site|
  File.write(File.join(site.dest, "fork-plugin-ran.txt"), "yes\n")
end
