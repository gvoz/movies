module Movies
  class Theatre < Cinema
    include TicketOffice

    attr_reader :halls, :periods

    PERIOD_ERROR = 'Расписание некорректно (пересекаются сеансы в одном зале)'.freeze

    def initialize(movies, &block)
      super
      @halls = []
      @periods = []
      instance_eval(&block) if block_given?
      raise ArgumentError, PERIOD_ERROR unless schedule_valid?
    end

    def show(time = nil, hall_name = nil)
      raise 'Укажите желаемое время просмотра фильма' if time.nil?
      start choice schedule_film(time, hall_name)
    end

    def schedule_film(time, hall_name)
      period = find_period(time, hall_name)
      raise 'Кинотеатр закрыт' if period.nil?

      selection(period)
    end

    def buy_ticket(time, hall_name = nil)
      period = find_period(time, hall_name)
      raise 'Кинотеатр закрыт' if period.nil?

      movie = choice selection(period)
      hall = find_hall(period, hall_name)
      put_money period.cost
      puts "Вы купили билет на #{movie.name} в #{hall.title}"
    end

    def when?(name)
      film = @movies.filter(name: name).first

      periods = @periods.select do |period|
        selection(period).include?(film)
      end

      if periods.empty?
        'Данный фильм не показывают в нашем кинотеатре'
      else
        periods.map(&:to_s).join(' или ')
      end
    end

    private

    def find_period(time, hall_name)
      selection = @periods.select do |period|
        period.interval.include?(Time.parse(time)) &&
          (hall_name.nil? || period.halls.map(&:title).include?(hall_name))
      end
      selection.sample
    end

    def find_hall(period, hall_name)
      if hall_name.nil?
        period.halls.sample
      else
        period.halls.select { |h| h.name == hall_name }.sample
      end
    end

    def period(interval, &block)
      @periods << Period.new(interval, self, &block)
    end

    def hall(hall_name, params)
      @halls << Hall.new(hall_name, params)
    end

    def schedule_valid?
      return true if @periods.empty?
      @periods.combination(2).none? do |a, b|
        !(a.interval & b.interval).nil? && (a.halls & b.halls).any?
      end
    end

    def selection(period)
      @movies.filter(period.name.nil? ? period.filter : { name: period.name } )
    end
  end
end
