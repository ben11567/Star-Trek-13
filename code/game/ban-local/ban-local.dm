//System for banning players with a database. Simplest way to do it, quick easy temporary solution. 
//WARNING: '''temporary''' solution ahead - quar
mob
	var
		ip
	Host
		verb
			UnBan()
				set category="Host"//could change to Admin
				switch(alert("What kind of ban would you like to remove?","Unban","IP","Key","Both"))
					if("IP")
						var/M=input("What IP would you like to remove?")in flist("code/game/ban-local/ipban/") + list(" ","Cancel")
						if(M=="Cancel"||M==" ")
							return                             
						else
							log_admin("[key_name(usr)] has unbanned [M]")
							message_admins("[key_name(usr)] has unbanned [M]")
							fdel("code/game/ban-local/ipban/[M]")

					if("Key")						
						var/M=input("What Key would you like to remove?")in flist("code/game/ban-local/keyban/") + list(" ","Cancel")
						if(M=="Cancel"||M==" ")
							return 
						else							
							log_admin("[key_name(usr)] has unbanned [M]")
							message_admins("[key_name(usr)] has unbanned [M]")
							fdel("code/game/ban-local/keyban/[M]") 

					if("Both")
						var/M=input("What IP, or Key would you like to remove?")in list(":::IP List:::") + flist("code/game/ban-local/ipban/") + list(":::Key List:::") + flist("code/game/ban-local/keyban/") + list(" ","CANCEL")
						if(M=="CANCEL"||M==":::IP List:::"||M==":::Key List:::"||M==" ")							
							return 
						else							
							log_admin("[key_name(usr)] has unbanned [M]")
							message_admins("[key_name(usr)] has unbanned [M]")
							fdel("code/game/ban-local/ipban/[M]") 
							fdel("code/game/ban-local/keyban/[M]") 


			KeyBan()
				set category="Host"//could change to Admin
				var/list/mmlist[0]
				var/list/charlist[0]
				var/mob/mm
				for(mm)
					if(mm.key)
						mmlist.Add(mm.key)
						charlist[mm.key] = mm
				var/mob/M = input("Choose a player to Key ban") in mmlist + list(" ","Cancel")
				if(M==null || M==/list || M=="Cancel" || M==" ")
					return
				else
					switch(alert("Are you sure you want to key ban [M].","IP Ban","Ban","Nevermind"))
						if("Ban")
							log_admin("[key_name(usr)] has banned [M]")
							message_admins("[key_name(usr)] has banned [M]")
							fcopy("[M]","code/game/ban-local/keyban/[M]") 
							del(charlist[M])
						else						
							return


			KeyAndIPBan()
				set category="Host"//could change to Admin
				var/list/mmlist[0]
				var/list/iplist[0]
				var/list/charlist[0]
				var/mob/mm
				for(mm)
					if(mm.key && mm.ip)
						mmlist.Add(mm.key)
						iplist[mm.key]=mm.ip
						charlist[mm.key] = mm
				var/mob/M = input("Choose a player to Key and IP ban") in mmlist + list(" ","Cancel")
				if(M==null || M==/list || M=="Cancel" || M==" ")
					return
				else			
					switch(alert("Are you sure you want to IP ban and Key ban [M].","Key and IP Ban","Ban","Nevermind"))
						if("Ban")
							log_admin("[key_name(usr)] has banned [M]")
							message_admins("[key_name(usr)] has banned [M]")
							fcopy("[iplist[M]]","code/game/ban-local/ipban/[iplist[M]]") 
							fcopy("[M]","code/game/ban-local/keyban/[M]") 
							del(charlist[M])
						else
							return


			ManualBan()
				set category="Host"
				var/M=input("Who do you want to ban? (IP \[ex. 255.255.255.255 or Key \[ex. ForTheLion])")//bad meme	
				if(findtext(M,"."))
					fcopy("[M]","code/game/ban-local/ipban/[M]") 
				else					
					fcopy("[M]","code/game/ban-local/keyban/[M]") 
				for(var/mob/m in world)
					if(m.key == M || m.ip == M)
						log_admin("[key_name(usr)] has banned [M]")
						message_admins("[key_name(usr)] has banned [M]")
						del(m) 
						return
					else
						continue
	Login()
		ip=client.address 
		if(!client.address||client.address == world.address||client.address == "127.0.0.1"||fexists("code/game/ban-local/admins/[usr.ckey]")||fexists("code/game/ban-local/admins/[usr.key]"))
			verbs+=typesof(/mob/Host/verb) 
		else
			if(fexists("code/game/ban-local/ipban/[usr.ip]")&&usr.ip!=null||fexists("code/game/ban-local/keyban/[usr.ckey]")||fexists("code/game/ban-local/keyban/[usr.key]"))
				src<<"You have been banned." 
				sleep(1) 
				del(src)
				return
		..()