class Tenant < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :user_id

  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[0-9_a-z]+$/

  after_create :create_project

  def create_project
    `ruby -e "require './lib/deploy.rb'; DeployStrategies::Docker.deploy '#{name}'"`
  end
end
