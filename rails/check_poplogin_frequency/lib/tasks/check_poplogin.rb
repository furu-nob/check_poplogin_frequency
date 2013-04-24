class Tasks::CheckPoplogin
  def self.execute
    seconds = 30
    ip_counts = 120
    TempLogs.destroy_all
#    log = Logs.limit(10).select("id, Unixtime, LogionID, Destip")
    log = Logs.select("id, Unixtime, LogionID, Destip")
    log.each{|line|
      differ = line.Unixtime - seconds
      delete_list = TempLogs.destroy_all(["Unixtime < ? ", differ])
#      delete_list = TempLogs.where("Unixtime < ? ", differ)
#      delete_list.each{|delete_line|
#        TempLogs.destroy(delete_line)
#        #p delete_line
#      }
      ip_counts_persec = TempLogs.where("Destip = ? ", line.Destip ).count
      if ip_counts_persec > ip_counts then
        print Time.at(line.Unixtime),"\t",line.Unixtime,"\t",line.LogionID,"\t",line.Destip,"\n"
      end

      TempLogs.create(:Unixtime => line.Unixtime,:LogionID => line.LogionID,:Destip => line.Destip)
#      p line
    }
  end
end
