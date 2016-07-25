class Spina::Category < ApplicationRecord
  has_many :articles

  attr_accessor :old_materialized_path

  validates :name, presence: true
  validates :slug, uniqueness: true

  before_validation :set_slug

  def materialized_path
     "/categories/#{slug}"
  end

  def next_article
    self.class.where("id > ?", id).order("id ASC").first
  end

  def prev_article
    self.class.where("id < ?", id).order("id DESC").first
  end

  private

  def set_slug
    self.old_materialized_path = materialized_path
    self.slug = name.try(:parameterize)
    self.slug += "-#{self.class.where(slug: slug).count}" if self.class.where(slug: slug).where.not(id: id).count > 0
    slug
  end

  def rewrite_rule
   RewriteRule.create(old_path: old_materialized_path, new_path: materialized_path) if old_materialized_path != materialized_path
  end
end
