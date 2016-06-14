class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string      :name
      t.date        :creation_date
      t.references  :user

      t.timestamps
    end
  end
end
