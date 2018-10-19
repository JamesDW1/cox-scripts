contactId = 0

flintContact = 0;
flintLocation = vec3.new(-62.0, 0.0, 182.0)

parksContact = 0;
parksLocation = vec3.new(-83.0, 0.0, 1334.0)

contact_list = function(contacts)
    
    return ""
end

entity_interact = function(id)
    printDebug("entity id " .. tostring(id))
    contactId = id

    if id == 5 or id == 16781309 then
        id = 5 -- id 16781309 is from the call button. Its a different entity than normal.
        contactId = 5
        contactAvailable(id)
    elseif id == 3 then
        contactAvailable(id)
    elseif id == 2 then
        contactAvailable(id)
    elseif id == 38 then
        contactAvailable(id)
    elseif id == 39 then
        contactAvailable(id)
    else
        MapClientSession.browser(client,"Hello")
    end
    return ""
end

dialog_button = function(id)
    printDebug("buttonId: " .. tostring(id))
    if contactId == 5 then --Officer Flint
        officerFlintDialogs(id)
    elseif contactId == 2 then --Officer Parks
        officerParksDialogs(id)
    end

    return ""
end

set_target = function(id) 
    printDebug("target id " .. tostring(id))
    Character.faceEntity(client.m_ent, id)
    return ""
end

function contactAvailable(id)
    if id == 5 then
        if flintContact == 0 then
            flintContact = Contact.new()
            flintContact.npcId = 1939
            flintContact.name = "Officer Flint"
            flintContact.currentStanding = 0
            flintContact.notifyPlayer = true
            flintContact.taskIndex = 1
            flintContact.hasLocation = true
            flintContact.locationDescription = "Outbreak"
            flintContact.friendThreshold = 2
            flintContact.confidantThreshold = 3
            flintContact.completeThreshold = 4
            flintContact.canUseCell = false
            Character.addUpdateContactList(client, flintContact, flintLocation)
        end
        officerFlintDialogs(nil)
    elseif (id == 3 and flintContact.currentStanding >= 1) then
        drMillerDialogs(nil)
    elseif id == 2 then
        if parksContact == 0 then
            parksContact = Contact.new()
            parksContact.npcId = 1940
            parksContact.name = "Officer Parks"
            parksContact.currentStanding = 0
            parksContact.notifyPlayer = true
            parksContact.taskIndex = 1
            parksContact.hasLocation = true
            parksContact.locationDescription = "Outbreak"
            parksContact.friendThreshold = 2
            parksContact.confidantThreshold = 3
            parksContact.completeThreshold = 4
            parksContact.canUseCell = false
            Character.addUpdateContactList(client, parksContact, parksLocation)
        end
        officerParksDialogs(nil)
    elseif id == 38 then
        professorHoffman(nil)
    elseif id == 39 then
        macReady(nil)
    else
        --other contacts
    end
end

function officerFlintDialogs(buttonId)
    if buttonId == nil then
        if flintContact.currentStanding == 0 then
            local message = [[<img src="npc:1939" align="left"><br><br>We have a crisis going on here, and we need help desperately. 
            Some thugs took an experimental drug thinking it was something else, and now they're trashing the area.
            We have to regain control to ensure the safey of the citizens.<br><br>
            <color #2189b9>Click on "Ask about available missions" to proceed.</color><br><br><br>]]
            local buttons = {
                button1 = {"Ask about available missions","CONTACTLINK_MISSIONS"},
                button2 = {"Ask about this contact","CONTACTLINK_ABOUT"},
                button3 = {"",""},
                button4 = {"Leave","CONTACTLINK_BYE"} 
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 1 then
            message = [[<img src="npc:1939" align="left">Hurry to Dr. Miller! He is waiting on the sample.]] 
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 2 then
            message = [[<img src="npc:1939" align="left">I have nothing more for you right now.]] 
            local buttons = {
                button1 = {"Leave" ,"CONTACTLINK_BYE"} 
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 3 then
            message = string.format([[<img src="npc:1939" align="left"><br>Excellent job. What did you call yourself again? Was it %s? That's pretty original. 
            You seem to navigate well,so let me tell you about the Map. 
            Click the Map Button to bring up an overhead view of the zone.<br><br><img src=Tut_Menu_Map.tga><br><br>
            <color #2189b9>Click on any item on the map to target it. The target appears on your compass.</color>]],heroName)
            local buttons = {
                button1 = {"Be introduced to a new contact","CONTACTLINK_INTRODUCE_CONTACT1"},
                button2 = {"Ask about this contact","CONTACTLINK_ABOUT"},
                button3 = {"",""},
                button4 = {"Leave" ,"CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 4 then
            message = string.format("You should go see Officer Parks now, %s. There's nothing more you can do for me.",heroName)
            local buttons = {
                button1 = {"Leave" ,"CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        end
    elseif buttonId == 4 then
        message = [[We need an antidote for the berserk thugs. I've collected this blood sample. <a href=CONTACTLINK_MISSIONS>Please take it to Dr. Miller;</a>
        he's marked on your map and compass.<br><br>
        <color #2189b9>The Navigation Window is at the top center of your screen.</color><br><br>
        <img src="Tut_Compass"><br><br>
        <color #2189b9>You have been issues a clue. You can learn more about the clue by clicking the Clues button on your Nav window. 
        Whenever you are issues new Clues, you can read more about them there as well.</color><br><br><br>]] 
        local buttons = {
            button1 = {"Click here to accept this task" ,"CONTACTLINK_ACCEPTLONG"},
            button2 = {"Talk about what else is going on","CONTACTLINK_ABOUT"},
            button3 = {"",""},
            button4 = {"Leave", "CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)
    elseif buttonId == 3 then
        printDebug("Contact bye message. Close dialog")
        MapClientSession.close_dialog(client)

    elseif buttonId == 10 then
        flintContact.currentStanding = 4
        Character.addUpdateContactList(client, flintContact, flintLocation)

        message = [[Officer Parks radioed. He needs help fighting off some rioting thugs down the street.<br>
        <img src="npc:1940" align="left"><b>Officer Parks</b><br><br>By selecting Officer Parks as a Contact you can now receive tasks and information from him. 
        When your current Contact is happy with your work and can trust you, they will introduce you to their friends,who in turn will have more work that needs to get done.<br><br>
        Use this to keep adding new Contacts as you adventure in Paragon City.]]
        local buttons = {  
            button1 = {"Talk about what else is going on","CONTACTLINK_ABOUT"},
            button2 = {"",""},
            button3 = {"Leave","CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)

        parksContact = Contact.new()
        parksContact.npcId = 1940
        parksContact.name = "Officer Parks"
        parksContact.currentStanding = 0
        parksContact.notifyPlayer = true
        parksContact.taskIndex = 1
        parksContact.hasLocation = true
        parksContact.locationDescription = "Outbreak"
        parksContact.friendThreshold = 2
        parksContact.confidantThreshold = 3
        parksContact.completeThreshold = 4
        parksContact.canUseCell = false
        Character.addUpdateContactList(client, parksContact, parksLocation)
        
    elseif buttonId == 20 then
        message = ""
        local buttons = {}
        if flintContact.currentStanding == 4 then
            message = string.format("You should go see Officer Parks now, %s. There's nothing more you can do for me.",heroName)
            buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
        else
            message = [[<img src="npc:1939" align="left"><br><br>Officer Flint has simple duties in the Paragon City Police Department, but when a crisis arises he's always first to volunteer for extra duty.
            His friendly nature and good heart make him an ideal contact for new heroes learning their way around Paragon City.<br>]]
            buttons = {
                button1 = {"Ask about available missions","CONTACTLINK_MISSIONS"},
                button2 = {"",""},
                button3 = {"Leave","CONTACTLINK_BYE"}
            }
        end
        MapClientSession.contact_dialog(client,message,buttons)
    elseif buttonId == 7 then
        flintContact.currentStanding = 1
        MapClientSession.sendFloatingInfo(client,5)
        message = [[<img src="npc:1939" align="left">Dr. Miller is just down the street. Give him the sample,and see if he has anything further for you.]]
        local buttons = {
            button1 = {"Ask about this contact", "CONTACTLINK_ABOUT"},
            button2 = {"",""},
            button3 = {"Leave","CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)
    else

    end
end

function drMillerDialogs(buttonId)
    if buttonId == nil then
        if flintContact == nil then
            message = [[I don't know you.</color>]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 1 then
            flintContact.currentStanding = 2
            Character.addUpdateContactList(client, flintContact, flintLocation)
            
            Character.giveXp(client,50)
            Character.giveEnhancement(client,"Generic_Damage",5);

            message = [[Thank you! This sample will help our reseach immensely.<br><br>Since you are new to paragon city,you should familiarize yourself with the way hospitals work here.            
            <color #2189b9>There is an Information Terminal in front of Rivera Medical Center next to me you need to read.</color>]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
            
        elseif flintContact.currentStanding == 2 then
            message = [[<color #2189b9>There is an Information Terminal in front of Rivera Medical Center next to me you need to read.</color>]]
            local buttons = {
            button1 = {"Leave", "CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif flintContact.currentStanding == 3 then
            message = [[Talk to Officer flint. I think he has something more for you.]] 
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message, buttons)
        end
    elseif buttonId == 3 then
        printDebug("Contact bye message. Close dialog")
        MapClientSession.close_dialog(client)
    end
end

function officerParksDialogs(buttonId)
    if buttonId == nil then
        if(flintContact == 0 or flintContact.currentStanding ~= 4 ) then
            message = [[<img src="npc:1940" align="left"><br><br>You need to finish your work for Officer Flint before you can help me.]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif parksContact.currentStanding == 0 then
            message = string.format([[<img src="npc:1940" align="left"><br><br>You must be %s. I sure hope you can help. First, let me explain how to use your powers. 
            Your Powers Tray located at the bottom of the screen contains an icon for each of your powers.<br>
            <img src=Tut_Menu_Powers.tga><br>Left click the icon to use the power, or right click the icon to learn about the power. 
            You can use the Powers tab to add new powers to your tray whenever you recieve them.<br><br><br>
            <color #2189b9>Click on "Ask about available missions" to proceed.</color><br><br><br>]], heroName)
            local buttons = {
                button1 = {"Ask about available missions","CONTACTLINK_MISSIONS" },
                button2 = {"Ask about this contact","CONTACTLINK_ABOUT"},
                button3 = {"",""},
                button4 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        end

    elseif buttonId == 3 then
        printDebug("Contact bye message. Close dialog")
        MapClientSession.close_dialog(client)

    elseif buttonId == 4 then
        message = string.format([[<img src="npc:1940" align="left"><br><br>Things are getting out of control, and I can tell you need to learn all about combat, %s.
        First, I want you to learn about how tought things can be by talking to Professor Hoffman in front of the deactivated robots right in front of me.
        Then talk to Lt. MacReady for your combat lesson, then I want you to com back and talk to me.]], heroName )
        local buttons = {
            button1 = {"Click here to accept this task" ,"CONTACTLINK_ACCEPTLONG"},
            button2 = {"Talk about what else is going on","CONTACTLINK_ABOUT"},
            button3 = {"",""},
            button4 = {"Leave", "CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)
    elseif buttonId == 6 then
        parksContact.currentStanding = 1
        Character.addUpdateContactList(client, parksContact, parksLocation)

        message = string.format([[<img src="npc:1940" align="left"><br><br>Things are getting out of control, and I can tell you need to learn all about combat, %s.
        First, I want you to learn about how tought things can be by talking to Professor Hoffman in front of the deactivated robots right in front of me.
        Then talk to Lt. MacReady for your combat lesson, then I want you to com back and talk to me.]], heroName )
        local buttons = {
            button1 = {"Click here to accept this task" ,"CONTACTLINK_ACCEPTLONG"},
            button2 = {"Talk about what else is going on","CONTACTLINK_ABOUT"},
            button3 = {"",""},
            button4 = {"Leave", "CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)

    elseif buttonId == 7 then
        parksContact.currentStanding = 2
        Character.addUpdateContactList(client, parksContact, flintLocation)
        message = [[<img src="npc:1940" align="left"><br><br>Talk to Professor Hoffman, then Lt. MacReady]]
        local buttons = {
            button1 = {"Leave", "CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)

    elseif buttonId == 14 then
        message = [[<img src="npc:1940" align="left"><br><br>Officer Parks has walked the streets of Paragon City since he was a young man. 
        He takes great pride and pleasure in doing his part to keep the city of heroes safe.<br>]]
        local buttons = {
            button1 ={"Ask about available missions","CONTACTLINK_MISSIONS" },
            button2 = {"",""},
            button3 = {"Leave","CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)
    else
    end
end

function professorHoffman(buttonId)
    if buttonId == nil then
        if parksContact == 0 then
            message = [[Talk to Officer Parks]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif parksContact.currentStanding ==2 then
            parksContact.currentStanding = 3
            Character.addUpdateContactList(client, parksContact, parksLocation)
            message = [[Here we have some deactivated robots. If you left click on them you can target them. 
            This is how you determine which enemy you are attacking.<br><br>You can also Consider (or 'con') your target and note the level difference to your character by the color of the name.
            White names mean they are the same level as yourself, <color #ff9900>Orange names</color> mean they are one level stronger than you, and <color #0000ff>Blue names</color> mean they are one level weaker than you.
            There are other colors for even stronger or weaker enemies.<br><br>There are also three different types of enemies at each level, these are <color #ffff00>Minions</color>, 
            <color #ff9900>Lieutenants</color>, and <color #ff0000>Bosses</color>. <color #ffff00>Minions</color> are the weakest and you should be able to defeat these easily. <color #ff9900>Lieutenants</color> are stronger, 
            and have more attacks and can take more damage. Finally <color #ff0000>Bosses</color> are the strongest, and even if a Boss 'cons' green to you, you are in for a tough fight.<br>
            <br>Now go see Lt. MacReady and learn about how to deal with your foes.]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        end
    elseif buttonId == 3 then
            MapClientSession.close_dialog(client)
    elseif (buttonId ~= nil and parksContact.currentStanding == 3) then
        message = [[You need to talk to Lt. MacReady and learn about combat.]]
        local buttons = {
            button1 = {"Leave","CONTACTLINK_BYE"}
        }
        MapClientSession.contact_dialog(client,message,buttons)
    end
end

function macReady(buttonId)
    if buttonId == nil then
        if parksContact == 0 then
            message = [[Talk to Officer Parks]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        elseif parksContact.currentStanding == 3 then
            parksContact.currentStanding = 4
            Character.addUpdateContactList(client, parksContact, parksLocation)
            message = string.format( "So you're %s, eh?", heroName) .. [[ Well, I've been told you need to learn a thing or two about combat. 
            First off, you need to <color #0000ff>Target</color> the enemy you want to attack by clicking on them with your left mouse button, 
            or use the Tab key to cycle targeted enemies.<br><br>Once you have your enemy targeted you can attack them by simply clicking the power in your power tray, 
            or hit the appropriate <color #ffff00>Number Key</color>.<br><br>After you use a power it takes time to recharge. 
            The icon will go small, and grow larger until it returns to its original size. Once the icon is normal sized, the power can be used again.
            <br><br>You can take some practice shots at any of these deactivated drones, to get used to your powers. When you are done, go see Officer Parks for an assignment.]]
            local buttons = {
                button1 = {"Leave","CONTACTLINK_BYE"}
            }
            MapClientSession.contact_dialog(client,message,buttons)
        end
    else

    end
end