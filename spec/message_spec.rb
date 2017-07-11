require "spec_helper"

module Watsbot
  RSpec.describe Message do

    before do
      Watsbot.configure do |config|
        config.username  = ENV["WATSON_USERNAME"],
        config.password  = ENV["WATSON_PASSWORD"],
        config.workspace = ENV["WATSON_WORKSPACE"],
        config.version   = ENV["WATSON_WORKSPACE_VERSION"],
        config.redis_url = ENV["REDIS_URL"],
        config.ttl       = ENV["TTL"].to_i
      end
    end

    describe "#send" do
      context "invalid" do
        it "raises error - no uid" do
          message = Watsbot::Message.new
          expect { message.send(nil, "Hi") }.to raise_error("uid should be provided")
        end
        it "raises error - no message" do
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          expect { message.send(uid, nil) }.to raise_error("message should be provided")
        end
        it "raises error - blank uid" do
          message = Watsbot::Message.new
          expect { message.send("", "Hi") }.to raise_error("uid should be provided")
        end
        it "raises error - blank message" do
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          expect { message.send(uid, "") }.to raise_error("message should be provided")
        end
        it "raises error - wrong-formatted context" do
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          expect { message.send(uid, "hi", {context: "{1}"}) }.to raise_error(TypeError)
        end
        it "responds with error state - no version" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=")).to_return(fixture_path("message/error.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          Watsbot.configuration.version = nil
          response = message.send(uid, "Hi")
          expect(response.class).to eq(Response::Error)
          Watsbot.configuration.version = ENV["WATSON_WORKSPACE_VERSION"]
        end
      end
      context "valid" do
        it "responds with success state" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          response = message.send(uid, "Hi")
          expect(response.class).to eq(Response::Success)
        end
        it "stores the context" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          response = message.send(uid, "Hi")
          expect(message.state.fetch(uid)).to eq(response.context.to_json)
        end
        it "pass context" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          context = JSON.parse message.state.fetch(uid)
          response = message.send(uid, "Good", {context: context})
          expect(message.state.fetch(uid)).to eq(response.context.to_json)
        end
        it "terminates conversation" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          context = JSON.parse message.state.fetch(uid)
          message.send(uid, "Good", {context: context, terminated: true})
          expect(message.state.fetch(uid)).to eq(nil)
        end
        it "sends custom context variable" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi", {context: {username: "pamit"}})
          context = JSON.parse message.state.fetch(uid)
          expect(message.state.fetch(uid)).not_to eq(nil)
        end
        it "sends new message again" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          message.state.delete(uid)
          expect(message.state.fetch(uid)).to eq(nil)
          message.send(uid, "Hi")
          expect(message.state.fetch(uid)).not_to eq(nil)
        end
        it "does not change ttl" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          expect(message.state.ttl(uid)).to eq(-1)
        end
        it "sets ttl" do
          Watsbot.configure do |config|
            config.ttl       = 60
          end
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          expect(message.state.ttl(uid)).to be_between(1, Watsbot.configuration.ttl)
        end
      end
    end

  end
end
