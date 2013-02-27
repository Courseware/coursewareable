class FixAllowedSpaceIntegerSizeForCoursewareablePlan < ActiveRecord::Migration
  def change
    change_column :coursewareable_plans, :allowed_space, :integer, :limit => 8
  end
end
