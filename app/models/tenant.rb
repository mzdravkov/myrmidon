class Tenant < ActiveRecord::Base
  belongs_to :user
  has_many :plugins

  validates :name, presence: true, uniqueness: true
  validates_format_of :name, :with => /^[0-9_a-z]+$/

  attr_accessible :name, :user_id

  after_create :create_project

  def create_project
    unless Kernel.system("#{ENV['kamino_bin']} deploy -name='#{name}'")
      throw 'Error creating tenant'
    end
  end

  def configs
    YAML.load_file(File.join(ENV['tenants_configs_dir'], name + '.yml'))
  end

  def update_configs changes
    conf = configs
    changes.each do |k, v|
      if conf[k]['type'] == 'bool'
        conf[k]['value'] = (v == 'true')
      else
        conf[k]['value'] = v
      end
    end
    file = File.join(ENV['tenants_configs_dir'], name + '.yml')
    File.open file, 'w' do |f|
      f.print conf.to_yaml
    end
  end
end
