class FixAllowedSpaceIntegerSizeForCoursewareablePlan < ActiveRecord::Migration
  def change
    change_table :coursewareable_plans do |t|
      t.integer :allowed_space, :limit => 8
    end
  end
end
