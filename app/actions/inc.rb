class Inc < Dynflow::Action
  def plan(n)
    plan_self(:n => n)
  end

  def run
    output[:result] = input[:n] + 1
  end
end
