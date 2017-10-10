has_app_changes = git.modified_files.grep(/app\//).any? ||
                  git.modified_files.grep(/lib\//).any?

# Add a CHANGELOG entry for app changes
if !git.modified_files.include?("CHANGELOG.md") && has_app_changes
  fail("Please include a CHANGELOG entry.\n"\
       "You can find it at [CHANGELOG.md]\n"\
       '(https://github.com/barnardos/consent-form-builder-rails/blob/master/CHANGELOG.md).')
  message 'Note, we hard-wrap at 80 chars and use 2 spaces after the last line.'
end

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "WIP"
