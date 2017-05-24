
def spec_dir
  File.join Watsbot.root, "spec"
end

def fixture_dir
  File.join spec_dir, "fixtures"
end

def watson_uri(path)
  Watsbot::BASE_URI + path
end

def watson_ruri(path)
  %r{#{watson_uri(path)}}
end

def fixture_path(file)
  File.new File.join(fixture_dir, file)
end
