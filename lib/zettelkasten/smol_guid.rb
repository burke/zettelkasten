require 'zettelkasten'

require 'set'

module Zettelkasten
  class SmolGUID
    # always a string prefix followed by a space
    def self.from(string)
      sd = string.split(' ', 2).first
      parse(sd)
    end

    REGISTRY = {}

    def self.register(smol_date, index)
      set = (REGISTRY[smol_date.to_s] ||= Set.new)
      if set.include?(index)
        STDERR.puts "[warn] duplicate SmolGUID #{smol_date}.#{index.to_s(36)}"
      end
      set << index
    end

    def self.parse(smol_guid)
      return SmolGUID.next if smol_guid == "#"
      if smol_guid.nil?
        puts "[warn] invalid smolguid"
        return
      end

      if smol_guid =~ /^__(.*)__$/
        smol_guid = $1
      end

      smol_date, index = smol_guid.split('.', 2)
      new(smol_date, index.to_i(36))
    end

    def initialize(smol_date, index)
      @smol_date = smol_date
      @index = index
      SmolGUID.register(smol_date, index)
    end

    def to_s
      "__#{@smol_date}.#{@index.to_s(36)}__"
    end

    def self.next
      sd = SmolDate.current
      set = (REGISTRY[sd.to_s] ||= Set.new)
      i = 1
      loop do
        unless set.include?(i)
          return new(sd, i)
        end
        i += 1
      end
    end
  end
end
