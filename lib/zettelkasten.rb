require 'open3'
require 'yaml'

module Zettelkasten
  def self.run
    config = YAML.load_file(File.expand_path('~/.config/zettelkasten/config.yml'))
    token = config.fetch('dynalist_api_token')
    if md = token.match(/^keychain:(.*)$/)
      token, _, t = Open3.capture3('security', 'find-generic-password', '-w', '-l', md[1])
      abort 'missing dynalist-token' unless t.success?
      token.strip!
    end
    note_id = config.fetch('zettelkasten_note_id')
    dynalist = Zettelkasten::Dynalist.new(zettelkasten_note_id: note_id, dynalist_api_token: token)

    dynalist.run_id_maintenance
  end
end

require 'zettelkasten/version'
require 'zettelkasten/smol_guid'
require 'zettelkasten/smol_date'
require 'zettelkasten/dynalist'
require 'zettelkasten/dynalist/node'
