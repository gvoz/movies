require_relative '../app/movies'
Money.use_i18n = false

describe Movies::TicketOffice do
  let(:dummy_class) { Class.new { extend Movies::TicketOffice } }
  before { dummy_class.put_money(100) }

  it { expect { dummy_class.put_money(100) }.to change{ dummy_class.cash }.from('$1.00').to('$2.00') }
  it { expect{ dummy_class.take('Any') }.to raise_error("Вызываем полицию") }
  it { expect{ dummy_class.take('Bank') }.to output(/Проведена инкассация/).to_stdout }
  it { expect{ dummy_class.take('Bank') }.to change{ dummy_class.cash }.from('$1.00').to('$0.00') }
end
