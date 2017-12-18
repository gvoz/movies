module Movies
  class Netflix < Cinema
    extend TicketOffice

    attr_reader :balance

    def initialize movies
      super movies
      @balance = Money.new(0)
    end

    def show params
      film = choice params.nil? ? @movies.all : @movies.filter(params)
      film_cost = Money.new(cost(film) * 100)
      raise "Баланс #{@balance.format}, невозможно показать фильм за #{film_cost.format}" if film_cost > @balance
      @balance -= film_cost
      start film
    end

    def pay money
      raise 'Неправильная сумма' if money.negative?
      Netflix.put_money(money * 100)
      @balance += Money.new(money * 100)
    end

    def how_much? name
      Money.new(cost(@movies.filter(name: name).first) * 100).format
    end

    def cost film
      raise "Фильм не найден" if film.nil?
      case film.period
      when :ancient
        1
      when :classic
        1.5
      when :modern
        3
      when :new
        5
      end
    end
  end
end
