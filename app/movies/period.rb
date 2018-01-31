# frozen_string_literal: true

module Movies
  class Period
    attr_reader :name, :filter, :cost, :halls, :interval

    def initialize(interval, theatre, &block)
      @interval = Time.parse(interval.min)..Time.parse(interval.max)
      @theatre = theatre
      @halls = []
      instance_eval(&block) if block_given?
    end

    def tickets
      @halls.map(&:places).reduce(:+)
    end

    def to_s
      "#{@description}: "\
      "#{@interval.begin.strftime('%H:%M')} - #{@interval.end.strftime('%H:%M')},"\
      " #{@halls.map(&:title).join(', ')}"
    end

    private

    def description(str)
      @description = str
    end

    def filters(params)
      @filter = params
    end

    def hall(*names)
      @halls = names.map do |name|
        @theatre.halls.select { |hall| hall.name == name }.first ||
          raise(ArgumentError, "Зала #{name} нет в кинотеатре")
      end
    end

    def price(value)
      @cost = value * 100
    end

    def title(str)
      @name = str
    end
  end
end
