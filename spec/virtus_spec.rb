require 'pry'
require_relative '../app/movies'

describe Virtus, 'duration attribute' do
  let(:model) {
    Class.new {
      include Virtus.model

      attribute :duration, Duration
    }
  }

  it 'minutes' do
    expect(model.new(duration: '120 min').duration).to eql(120)
  end

  it 'not minutes' do
    expect { model.new(duration: '2 hour') }.to raise_error(RuntimeError, 'Продолжительность фильма должна быть в минутах')
  end
end
