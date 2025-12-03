#  Copyright 2022 Terra Enabling Developers Limited
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'httparty'
require 'json'
require 'API/TerraError'
require 'API/TerraResponse'

module Users 
    def self.get_user(dev_id, api_key, api_path, user_id)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        res = HTTParty.get(
            "#{api_path}/userInfo?user_id=#{user_id}", 
            :headers=>options["headers"]
        )

        case res.code
            when 200
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end

    def self.get_users_by_reference(dev_id, api_key, api_path, reference_id)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        res = HTTParty.get(
            "#{api_path}/userInfo?reference_id=#{reference_id}", 
            :headers=>options["headers"]
        )

        case res.code
            when 200
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end

    def self.get_users_bulk(dev_id, api_key, api_path, user_ids)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        res = HTTParty.post(
            "#{api_path}/userInfo",
            :headers => options["headers"],
            :body => { "user_ids" => user_ids }.to_json
        )

        case res.code
            when 200
                return TerraResponse::parseBody(res)
            when 400...600
                raise TerraError.new(res)
        end
    end

    def self.deauth_user(dev_id, api_key, api_path, user_id)
        options = {
            "headers" => {
                "X-API-Key" => api_key,
                "dev-id" => dev_id,
                "Content-Type" => "application/json",
            },
        }

        begin
            res = HTTParty.delete("#{api_path}/auth/deauthenticateUser?user_id=#{user_id}", :headers=>options["headers"])
        rescue HTTParty::Error => e
            raise TerraError.new(e)
        else 
            return TerraResponse::parseBody(res) 
        end
    end
end