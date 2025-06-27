class Incoming < Expense

  def expense?
    false
  end

  def incoming?
    true
  end
end
