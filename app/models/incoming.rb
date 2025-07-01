class Incoming < Transaction

  belongs_to :money_account
  belongs_to :user
  belongs_to :category, optional: true

  def expense?
    false
  end

  def incoming?
    true
  end
end
