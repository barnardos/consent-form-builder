module ApplicationHelper
  COMMIT_STEM = 'https://github.com/barnardos/consent-form-builder-rails/commit/'.freeze

  def link_to_current_sha(sha_getter = -> { `git rev-parse HEAD` })
    sha = ENV['HEROKU_SLUG_COMMIT'] || sha_getter.call
    return 'unavailable' if sha.nil?

    link_to sha[0..7], COMMIT_STEM + sha
  end
end
