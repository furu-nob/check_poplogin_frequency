class Tasks::ImportLog
  def self.execute
    logfile = '/Users/furuyamanobuyuki/github/check_poplogin_frequency/maillog.1'
    Logs.destroy_all
    #Logs.delete_all
    f = open(logfile,"r")
    f.each {|line|
      if md = line.match(/ login from /)
        splited = line.split(/\s+/)
#        p splited
#        print splited[5].split('.')[0],splited[7]
#        puts splited[10]
        Logs.create(:Unixtime => splited[5].split('.')[0],:LogionID => splited[7],:Destip => splited[10])
      end
    }
    f.close
    print ("Import", Logs.count, "lines.","\n")
  end
end
