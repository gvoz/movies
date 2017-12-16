module Movies
  module TicketOffice

    def cash
      (@money ||= Money.new(0)).format
    end

    def put_money cost
      @money ||= Money.new(0)
      @money += Money.new(cost)
    end

    def take who
      raise 'Вызываем полицию' unless who == 'Bank'
      @money = Money.new(0)
      puts 'Проведена инкассация'
    end
  end
end
