require 'zettelkasten'

require 'date'

module Zettelkasten
  class SmolDate
    def self.current
      new(Date.today)
    end

    def self.parse(smol_date)
      d = smol_date[-2..-1].to_i(16)
      m = smol_date[-3    ].to_i(16)
      y = smol_date[0..-3 ].to_i(10)
      Date.new(y, m, d)
    end

    def initialize(date)
      @date = date
      @smoldate = format("%x%x%02d", date.year - 2010, date.month, date.day)
    end

    def to_date
      @date
    end

    def to_s
      @smoldate
    end
  end
end
