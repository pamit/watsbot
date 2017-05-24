require "spec_helper"

module Watsbot
  RSpec.describe Configuration do

    after :each do
      Watsbot.reset
    end

    context "username" do
      it "should return default username from environment variable" do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("WATSON_USERNAME").and_return("test")
        Configuration.new.username
        expect(Configuration.new.username).to eq("test")
      end
      it "should set username" do
        config = Configuration.new
        config.username = "test"
        expect(config.username).to eq("test")
      end
      it "should set username with argument" do
        config = Configuration.new username: "test"
        expect(config.username).to eq("test")
      end
      it "should set username with block" do
        config = Configuration.new do |c|
          c.username = "username"
        end
        expect(config.username).to eq("username")
      end
    end

    context "password" do
      it "should return default password from environment variable" do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("WATSON_PASSWORD").and_return("test")
        Configuration.new.password
        expect(Configuration.new.password).to eq("test")
      end
      it "should set password" do
        config = Configuration.new
        config.password = "test"
        expect(config.password).to eq("test")
      end
      it "should set password with argument" do
        config = Configuration.new password: "test"
        expect(config.password).to eq("test")
      end
      it "should set password with block" do
        config = Configuration.new do |c|
          c.password = "password"
        end
        expect(config.password).to eq("password")
      end
    end

    context "workspace" do
      it "should return default workspace from environment variable" do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("WATSON_WORKSPACE").and_return("test")
        Configuration.new.workspace
        expect(Configuration.new.workspace).to eq("test")
      end
      it "should set workspace" do
        config = Configuration.new
        config.workspace = "test"
        expect(config.workspace).to eq("test")
      end
      it "should set workspace with argument" do
        config = Configuration.new workspace: "test"
        expect(config.workspace).to eq("test")
      end
      it "should set workspace with block" do
        config = Configuration.new do |c|
          c.workspace = "workspace"
        end
        expect(config.workspace).to eq("workspace")
      end
    end

    context "version" do
      it "should return default version from environment variable" do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("WATSON_WORKSPACE_VERSION").and_return("test")
        Configuration.new.version
        expect(Configuration.new.version).to eq("test")
      end
      it "should set version" do
        config = Configuration.new
        config.version = "test"
        expect(config.version).to eq("test")
      end
      it "should set version with argument" do
        config = Configuration.new version: "test"
        expect(config.version).to eq("test")
      end
      it "should set version with block" do
        config = Configuration.new do |c|
          c.version = "version"
        end
        expect(config.version).to eq("version")
      end
    end

    context "redis_url" do
      it "should return default redis_url from environment variable" do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("REDIS_URL").and_return("test")
        Configuration.new.redis_url
        expect(Configuration.new.redis_url).to eq("test")
      end
      it "should set redis_url" do
        config = Configuration.new
        config.redis_url = "test"
        expect(config.redis_url).to eq("test")
      end
      it "should set redis_url with argument" do
        config = Configuration.new redis_url: "test"
        expect(config.redis_url).to eq("test")
      end
      it "should set redis_url with block" do
        config = Configuration.new do |c|
          c.redis_url = "redis_url"
        end
        expect(config.redis_url).to eq("redis_url")
      end
    end

    context "base uri" do
      it "should return default base uri" do
        expect(Configuration.new.base_uri.nil?).to be false
        expect(Configuration.new.base_uri.length).to be > 0
      end
      it "should set base uri" do
        config = Configuration.new
        config.base_uri = "http://mycustom.url"
        expect(config.base_uri).to eq("http://mycustom.url")
      end
      it "should set base uri with block" do
        config = Configuration.new do |c|
          c.base_uri = "http://mycustomapi.url"
        end
        expect(config.base_uri).to eq("http://mycustomapi.url")
      end
    end

  end
end
