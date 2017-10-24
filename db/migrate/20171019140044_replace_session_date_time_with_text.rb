class ReplaceSessionDateTimeWithText < ActiveRecord::Migration[5.1]
  def up
    add_column :research_sessions, :when_text, :string
    ResearchSession.find_in_batches do |group|
      group.each do |session|
        next if session.start_datetime.nil?
        session.update_attribute(
          :when_text,
          session.start_datetime.strftime(
            "%A #{session.start_datetime.day.ordinalize} %B %Y at %I:%M%p"
          )
        )
      end
      remove_column :research_sessions, :start_datetime
    end
  end

  def down
    add_column :research_sessions, :start_datetime, :datetime
    ResearchSession.find_in_batches do |group|
      group.each do |session|
        next if session.when_text.nil?
        new_datetime = begin
          DateTime.strptime(session.when_text.gsub(/rd|th|st| at/, ''), '%A %e %B %Y %I:%M%p')
        rescue ArgumentError
          puts "ResearchSession##{session.id} couldn't parse when_text #{session.when_text}"
          nil
        end

        session.update_attribute(
          :start_datetime,
          new_datetime
        )
      end
    end
    remove_column :research_sessions, :when_text
  end
end
