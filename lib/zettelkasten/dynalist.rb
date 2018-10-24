require 'zettelkasten'

require 'open3'
require 'json'
require 'net/http'
require 'digest/sha1'
require 'date'
require 'set'

module Zettelkasten
  class Dynalist
    def initialize(zettelkasten_note_id:, dynalist_api_token:)
      @note_id = zettelkasten_note_id
      @token = dynalist_api_token
    end

    def run_id_maintenance
      Net::HTTP.start('dynalist.io', 443, use_ssl: true) do |http|
        req = Net::HTTP::Post.new('/api/v1/doc/read')
        req.body = {token: @token, file_id: @note_id}.to_json
        resp = http.request(req)
        data = JSON.parse(resp.body)
        if data["_code"] != "Ok"
          abort "nope"
        end

        data.fetch('nodes', []).each do |node|
          Node.load(node)
        end

        dirty_nodes = Node.select(&:dirty?)
        if dirty_nodes.empty?
          puts 'nothing to do'
        else
          print "updating #{dirty_nodes.size} nodes... "
          post_updated_node_contents(http, dirty_nodes)
          puts "ok!"
        end
      end
    end

    def post_updated_node_contents(http, nodes)
      req = Net::HTTP::Post.new('/api/v1/doc/edit')
      changes = nodes.map do |node|
        {
          action: 'edit',
          node_id: node.id,
          content: node.content,
        }
      end
      puts changes.inspect
      req.body = {token: @token, file_id: @note_id, changes: changes}.to_json

      resp = http.request(req)
      data = JSON.parse(resp.body)
      puts data.inspect

      if data["_code"] != "Ok"
        abort "nope"
      end
    end
  end
end

