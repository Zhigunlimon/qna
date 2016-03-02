class AddSetBestToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :set_best, :boolean
  end
end
