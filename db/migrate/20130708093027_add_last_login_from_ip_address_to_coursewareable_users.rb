class AddLastLoginFromIpAddressToCoursewareableUsers < ActiveRecord::Migration
  def change
    add_column(:coursewareable_users, :last_login_from_ip_address,
               :string, :default => nil)
  end
end
