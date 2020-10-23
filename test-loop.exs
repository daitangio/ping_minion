{:ok, server}=PingMinion.Scheduler.start_link()
:ok = PingMinion.Scheduler.schedule(server,["https://www.google.com", "https://www.google.com", "https://gioorgi.com", "https://gioorgi.com/ism/"])
# Empty ping to boot system and stabilize times
PingMinion.Scheduler.ping(server)

PingMinion.Scheduler.pingAndStore(server,"ping-test-report.csv") 

