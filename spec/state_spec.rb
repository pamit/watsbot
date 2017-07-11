require "spec_helper"

module Watsbot
  RSpec.describe State do

    describe "#fetch" do
      it "returns nil" do
        state = State.instance
        uid = SecureRandom.uuid
        expect(state.fetch(uid)).to be(nil)
      end
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        data = { data: {} }
        state.store(uid, data.to_json)
        expect(state.fetch(uid)).to eq(data.to_json)
      end
    end

    describe "#store" do
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        expect(state.fetch(uid)).to eq(nil)
      end
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        data = { data: {} }
        state.store(uid, data.to_json)
        expect(state.fetch(uid)).to eq(data.to_json)
      end
    end

    describe "#exists?" do
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        expect(state.exists?(uid)).to eq(false)
      end
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        data = { data: {} }
        state.store(uid, data.to_json)
        expect(state.exists?(uid)).to eq(true)
      end
    end

    describe "#delete" do
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        expect(state.delete(uid)).to eq(0)
      end
      it "returns data" do
        state = State.instance
        uid = SecureRandom.uuid
        data = { data: {} }
        state.store(uid, data.to_json)
        expect(state.delete(uid)).to eq(1)
      end
    end

    describe "#expire" do
      it "returns no data" do
        state = State.instance
        uid = SecureRandom.uuid
        state.store(uid, "hi")
        state.expire(uid, 10)
        expect(state.ttl(uid)).to be_between(1, 10)
      end
    end

    describe "#ttl" do
      it "returns ttl" do
        state = State.instance
        uid = SecureRandom.uuid
        state.store(uid, "hi")
        state.expire(uid, 10)
        expect(state.ttl(uid)).to be_between(1, 10)
      end
    end    
  end
end
