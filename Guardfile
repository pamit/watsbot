guard 'rspec', cmd: "rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # watch /lib/ files
  watch(%r{^lib\/watsbot\/(.+)\.rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

  # watch /spec/ files
  watch(%r{^spec\/(.+)\.rb$}) do |m|
    "spec/#{m[1]}.rb"
  end

  watch('spec/spec_helper.rb')  { "spec" }
end
