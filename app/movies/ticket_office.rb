module Movies
  module TicketOffice
    def money
      @money ||= Money.new(0)
    end

    def cash
      money.format
    end

    def put_money(cost)
      money
      @money += Money.new(cost)
    end

    def take(who)
      raise 'Вызываем полицию' unless who == 'Bank'
      @money = Money.new(0)
      puts 'Проведена инкассация'
    end
  end
end
