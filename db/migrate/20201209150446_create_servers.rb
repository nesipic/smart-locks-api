class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :code_name
      t.string :acces_token

      t.timestamps
    end
  end
end
