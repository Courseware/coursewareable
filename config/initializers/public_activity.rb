require 'public_activity'
require 'public_activity/activity'

PublicActivity::ORM::ActiveRecord::Activity.table_name =
  'coursewareable_activities'
