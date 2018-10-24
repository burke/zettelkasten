require 'open3'
require 'yaml'

module Zettelkasten
  def self.run
    config = YAML.load_file(File.expand_path('~/.config/zettelkasten/config.yml'))
    token   = fetch_config(config, 'dynalist_api_token')
    note_id = fetch_config(config, 'zettelkasten_note_id')
    dynalist = Zettelkasten::Dynalist.new(zettelkasten_note_id: note_id, dynalist_api_token: token)

    dynalist.run_id_maintenance
  end

  def self.fetch_config(config, key)
    str = config.fetch(key).to_s
    md = str.match(/^keychain:(.*)$/)
    return str unless md

    token, _, t = Open3.capture3('security', 'find-generic-password', '-w', '-l', md[1])
    abort 'missing dynalist-token' unless t.success?
    token.strip
  end
end

require 'zettelkasten/version'
require 'zettelkasten/smol_guid'
require 'zettelkasten/smol_date'
require 'zettelkasten/dynalist'
require 'zettelkasten/dynalist/node'
