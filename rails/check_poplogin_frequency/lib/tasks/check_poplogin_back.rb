class Tasks::CheckPoplogin_back
  def self.execute
    #seconds = 10
    self.refresh_temp
  end
  def self.refresh_temp
    temp = TempLogs.all
    temp.each {|line|
      p line
    }
    puts ("method")
  end
end
