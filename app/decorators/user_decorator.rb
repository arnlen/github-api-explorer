class UserDecorator < Draper::Decorator
  delegate_all

  def repository_counter
    model.repositories.count
  end
end
