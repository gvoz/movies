class Netflix < Cinema
  attr_reader :balance

  def initialize movies
    super movies
    @balance = 0
  end

  def show params
    film = choice params.nil? ? @movies.all : @movies.filter(params)
    film_cost = cost(film)
    raise "Баланс #{@balance} доллара, невозможно показать фильм за #{film_cost}" if film_cost > @balance
    @balance -= film_cost
    start film
  end

  def pay money
    raise 'Неправильная сумма' if money.negative?
    @balance += money
  end

  def how_much? name
    cost @movies.filter(name: name).first
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
