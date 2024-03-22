class Counter < ::Dynflow::Action
  def plan(upto)
    previous = plan_action(Inc, 0)
    upto.times do
      previous = plan_action(Inc, previous.output[:result])
    end
  end
end
