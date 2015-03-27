class Player

  attr_accessor :hand
  attr_reader :bankroll

  def initialize(bankroll)
    if bankroll.to_i == 0
      raise StandardError.new "Not a valid amount."
    end
    @bankroll = bankroll
  end

  def discard(indices)
    @hand.discard(indices)
  end

  def bet
  end

  def fold
  end

end
