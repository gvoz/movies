module Movies
  class Netflix < Cinema
    extend TicketOffice

    attr_reader :balance, :filters

    def initialize(movies)
      super movies
      @balance = Money.new(0)
      @filters = {}
    end

    def show(**params, &block)
      custom, standard = params.partition { |name, _| @filters.key?(name) }
      custom << block if block_given?

      @movies.filter(standard.to_h)
             .yield_self { |ms| custom_filter(ms, custom) }
             .yield_self { |ms| choice(ms) }
             .yield_self { |movie| check_balance(movie) }
    end

    def pay(money)
      raise 'Неправильная сумма' if money.negative?
      Netflix.put_money(money * 100)
      @balance += Money.new(money * 100)
    end

    def how_much?(name)
      @movies.filter(name: name).first
             .yield_self { |movie| cost(movie) * 100 }
             .yield_self { |mc| Money.new(mc).format }
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
      raise "Фильтр #{from} не найден" if @filters[from].nil?
      @filters[name] = ->(movie) { @filters[from].call(movie, arg) }
    end

    def custom_filter(films, params)
      params.reduce(films) do |movies, p|
        value = params[0].is_a?(Array) ? convert_filter(p[0], p[1]) : p
        movies.select(&value)
      end
    end

    def by_country
      CountrySelection.new(@movies)
    end

    def by_genre
      GenreSelection.new(@movies)
    end

    private

    def convert_filter(key, value)
      case value
      when true then @filters[key]
      when false then ->(movie) { !@filters[key].call(movie) }
      else ->(movie) { @filters[key].call(movie, value) }
      end
    end

    def check_balance(film)
      film_cost = Money.new(cost(film) * 100)
      if film_cost > @balance
        raise "Баланс #{@balance.format}, невозможно показать фильм за #{film_cost.format}"
      end
      @balance -= film_cost
      start film
    end
  end
end
