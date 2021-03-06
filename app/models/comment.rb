class Comment

  include MongoMapper::EmbeddedDocument

  key :user_id, ObjectId
  key :text, String, :required => true
  # generate data
  key :user_email, String
  key :created_at, Time

  belongs_to :user

  validate :user_is_member_of_project

  def update_informations
    self.user_email = self.user.email
    self.created_at ||= Time.now
  end

  def extract_words
    text.split(/[^\w]|[_]/)
  end

  def created_at=(date)
    write_attribute(:created_at, date) unless created_at
  end

  private

  def user_is_member_of_project
    unless self.created_at
      errors.add(:user, 'cant_access') unless self._root_document.project.member_include?(user)
    end
  end


end
