module ApplicationHelper
  COMMIT_STEM = 'https://github.com/barnardos/consent-form-builder-rails/commit/'.freeze

  def link_to_current_sha(sha_getter = -> { `git rev-parse HEAD` })
    sha = ENV['HEROKU_SLUG_COMMIT'] || sha_getter.call
    return 'unavailable' if sha.nil?

    link_to sha[0..7], COMMIT_STEM + sha
  end

  def title(research_session, step)
    if research_session.nil?
      I18n.t('application.title')
    elsif research_session.new_record?
      "#{I18n.t('application.create_new_form')} – #{I18n.t('application.title')}"
    elsif research_session.status == 'incentive' && step.nil?
      "Preview – #{research_session.name.strip}"
    else
      "#{step.to_s.humanize} – #{research_session.name.strip}"
    end
  end
end
