module Movies
  class Netflix < Cinema
    extend TicketOffice

    attr_reader :balance, :filters

    def initialize(movies)
      super movies
      @balance = Money.new(0)
      @filters = {}
    end

    def show(params = {}, &block)
      args = Hash process_filters(params)
      args[:block] = block if block_given?
      film = choice args.nil? ? @movies.all : @movies.filter(args)
      film_cost = Money.new(cost(film) * 100)
      if film_cost > @balance
        raise "Баланс #{@balance.format}, невозможно показать фильм за #{film_cost.format}"
      end
      @balance -= film_cost
      start film
    end

    def pay(money)
      raise 'Неправильная сумма' if money.negative?
      Netflix.put_money(money * 100)
      @balance += Money.new(money * 100)
    end

    def how_much?(name)
      Money.new(cost(@movies.filter(name: name).first) * 100).format
    end

    def cost(film)
      raise 'Фильм не найден' if film.nil?
      case film.period
      when :ancient then 1
      when :classic then 1.5
      when :modern then 3
      when :new then 5
      end
    end

    def define_filter(name, from: nil, arg: nil, &block)
      return @filters[name] = block if from.nil?
      @filters[name] = ->(movie) { @filters[from].call(movie, arg) }
    end

    private

    def convert_filter(key, value)
      case value
      when true then @filters[key]
      when false then ->(movie) { !@filters[key].call(movie) }
      else ->(movie) { @filters[key].call(movie, value) }
      end
    end

    def process_filters(params)
      params.each { |key, value| params[key] = convert_filter(key, value) if @filters.key?(key) }
    end
  end
end
