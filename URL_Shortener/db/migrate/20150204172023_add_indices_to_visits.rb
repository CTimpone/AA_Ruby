class AddIndicesToVisits < ActiveRecord::Migration
  def change
    add_index :visits, :visitor_id
    add_index :visits, :url_id
  end
end
