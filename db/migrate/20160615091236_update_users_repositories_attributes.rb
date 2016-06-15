class UpdateUsersRepositoriesAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :followers, :integer)
    remove_column(:users, :stars)

    add_column(:repositories, :stars, :integer)
  end
end
