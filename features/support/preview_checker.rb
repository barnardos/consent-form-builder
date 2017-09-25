module PreviewChecker
  def check_researcher
    expect(page.body).to include('Rachel Researcher')
    expect(page.body).to include('012345678')
    expect(page.body).to include('rachel@researcher.com')
  end

  def check_topic
    @topic.split("\n").each do |line|
      expect(page.body).to include(line)
    end
  end

  def check_purpose
    puts "#{__method__} not implemented"
  end

  def check_methodologies
    puts "#{__method__} not implemented"
  end

  def check_recording
    puts "#{__method__} not implemented"
  end

  def check_data
    puts "#{__method__} not implemented"
  end

  def check_time_equipment
    puts "#{__method__} not implemented"
  end

  def check_expenses
    puts "#{__method__} not implemented"
  end

  def check_incentive
    puts "#{__method__} not implemented"
  end
end

World PreviewChecker
