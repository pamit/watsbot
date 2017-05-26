require "spec_helper"

module Watsbot
  RSpec.describe Message do

    let(:valid_config) {
      Watsbot::Configuration.new(
        username:  ENV["WATSON_USERNAME"],
        password:  ENV["WATSON_PASSWORD"],
        workspace: ENV["WATSON_WORKSPACE"],
        version:   ENV["WATSON_WORKSPACE_VERSION"],
        redis_url: ENV["REDIS_URL"]
        )
    }

    describe "#send" do
      context "invalid" do
        it "raises error - no uid" do
          message = Watsbot::Message.new(valid_config)
          expect { message.send(nil, "Hi") }.to raise_error("uid should be provided")
        end
        it "raises error - no message" do
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          expect { message.send(uid, nil) }.to raise_error("message should be provided")
        end
        it "raises error - blank uid" do
          message = Watsbot::Message.new(valid_config)
          expect { message.send('', "Hi") }.to raise_error("uid should be provided")
        end
        it "raises error - blank message" do
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          expect { message.send(uid, '') }.to raise_error("message should be provided")
        end
        it "responds with error state - no version" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=")).to_return(fixture_path("message/error.txt"))
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          Watsbot.configuration.version = nil
          response = message.send(uid, "Hi")
          expect(response.class).to eq(Response::Error)
          Watsbot.configuration.version = ENV['WATSON_WORKSPACE_VERSION']
        end
      end
      context "valid" do
        it "responds with success state" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          response = message.send(uid, "Hi")
          expect(response.class).to eq(Response::Success)
        end
        it "stores the context" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          response = message.send(uid, "Hi")
          expect(Watsbot::State.instance.fetch(uid)).to eq(response.context.to_json)
        end
        it "pass context" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          context = JSON.parse Watsbot::State.instance.fetch(uid)
          response = message.send(uid, "Good", {context: context})
          expect(Watsbot::State.instance.fetch(uid)).to eq(response.context.to_json)
        end
        it "terminates conversation" do
          stub_request(:post, watson_uri("/workspaces/#{Watsbot.configuration.workspace}/message?version=#{Watsbot.configuration.version}")).to_return(fixture_path("message/created.txt"))
          message = Watsbot::Message.new(valid_config)
          uid = SecureRandom.uuid
          message.send(uid, "Hi")
          context = JSON.parse Watsbot::State.instance.fetch(uid)
          message.send(uid, "Good", {context: context, terminated: true})
          expect(Watsbot::State.instance.fetch(uid)).to eq(nil)
        end
      end
    end

  end
end
