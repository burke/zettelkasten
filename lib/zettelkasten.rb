module Zettelkasten
  def self.run
    token = begin
      token, _, t = Open3.capture3('security', 'find-generic-password', '-w', '-l', 'dynalist-token')
      abort 'missing dynalist-token' unless t.success?
      token.strip
    end
    note_id = 'Vys54zOGRMkMlgHHZLAbRyya'
    dynalist = Zettelkasten::Dynalist.new(zettelkasten_note_id: note_id, dynalist_api_token: token)

    dynalist.run_id_maintenance
  end
end

require 'zettelkasten/version'
require 'zettelkasten/smol_guid'
require 'zettelkasten/smol_date'
require 'zettelkasten/dynalist'
require 'zettelkasten/dynalist/node'
