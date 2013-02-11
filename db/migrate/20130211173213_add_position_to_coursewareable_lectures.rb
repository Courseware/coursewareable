class AddPositionToCoursewareableLectures < ActiveRecord::Migration
  def change
    add_column :coursewareable_lectures, :position, :integer, :default => 0
  end
end
