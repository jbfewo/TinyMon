class Step < MotionResource::Base
  attr_accessor :type, :position, :health_check_id
  attribute :data
  
  self.collection_url = "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps"
  self.member_url = "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  belongs_to :health_check
  
  def self.data_attribute(*fields)
    fields.each do |field|
      define_method field do
        self.data ||= {}
        self.data[field.to_s]
      end
      
      define_method "#{field}=" do |value|
        self.data ||= {}
        self.data[field.to_s] = value
      end
    end
  end
  
  def self.sort(array, &block)
    self.post(array.first.sort_url, :payload => { :step => array.map { |s| s.id } }, &block)
  end
  
  def create(&block)
    self.class.post(collection_url, :payload => { self.class.name.underscore => attributes }, :query => { :type => self.type.sub("Step", "").underscore }) do |response, json|
      self.class.request_block_call(block, json ? self.class.instantiate(json) : nil, response) if block
    end
  end
  
  def site_permalink
    health_check && health_check.site && health_check.site.permalink
  end
  
  def check_permalink
    health_check && health_check.permalink
  end
  
  def account_id
    health_check && health_check.account_id
  end
  
  def detail
    ""
  end
end
