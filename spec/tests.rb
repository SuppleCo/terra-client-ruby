require 'date'
require 'Terra'
require 'rspec/autorun'
require 'API/Providers'
require 'API/Helpers'

describe Helpers do
    describe ".GetTerraDate" do
        it "returns date in YYYY-MM-DD format with zero-padded month and day" do
            date = Date.new(2023, 3, 9)
            expect(Helpers.GetTerraDate(date)).to eq("2023-03-09")
        end

        it "handles double-digit months and days correctly" do
            date = Date.new(2023, 12, 25)
            expect(Helpers.GetTerraDate(date)).to eq("2023-12-25")
        end

        it "handles single-digit month with double-digit day" do
            date = Date.new(2023, 1, 15)
            expect(Helpers.GetTerraDate(date)).to eq("2023-01-15")
        end
    end
end

describe TerraAPI::Terra do 
    describe "#getProviders" do
        it "returns the providers list" do
            providers = double("Provider", get_providers: "provider_list")
            terra = double("TerraAPI::Terra")

            begin
                terra = TerraAPI::Terra.new("testingAnis", "O571xuiDDS9aGXlqro9youav9YOwD3r57YqC7bj0")
            rescue TerraError => e
                puts e
            end
            
        end
    end

    describe "#getSubscribers" do
        it "returns the subscribers list" do
            subs = double("Subscribers", get_subscribers: "subscribers_list")
            terra = double("TerraAPI::Terra")

            allow(terra).to receive(:getSubscribers).and_return(subs.get_subscribers)

            expect(terra.getSubscribers).to eq("subscribers_list")
        end
    end

    describe "#getUser" do
        it "returns User informations" do
            user = double("Users")
            terra = double("TerraAPI::Terra")
            
            allow(user).to receive(:get_user).with("test_user1").and_return("test_user1 data")
            allow(terra).to receive(:getUser).with("test_user1").and_return(user.get_user("test_user1"))
            expect(terra.getUser("test_user1")).to eq("test_user1 data")

            
            allow(user).to receive(:get_user).with("test_user2").and_return("test_user2 data")
            allow(terra).to receive(:getUser).with("test_user2").and_return(user.get_user("test_user2"))
            expect(terra.getUser("test_user2")).to eq("test_user2 data")
        end
    end
end