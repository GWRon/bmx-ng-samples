'===============================================================================
' Little Shooty Test Thing
' Code & Stuff by Richard Olpin (rik@olpin.net)
'===============================================================================
' Sound & Music
'===============================================================================

Global player_shot:TSound, playerdie:TSound
Global bombfall:TSound
Global explode:TSound, SoundChannel:TChannel, TempChannel:TChannel
Global music:TSound, MusicChannel:TChannel

Function InitSound()
	player_shot = LoadSound("sound/shot-1.wav", 0)
	playerdie = LoadSound("sound/explosion1.wav", 0)
	explode = LoadSound("sound/explode.wav", 0)
	bombfall = LoadSound("sound/bombfall.wav", 0)
	SoundChannel=AllocChannel()
	
	MusicChannel=AllocChannel()
'	music=LoadSound("sound/music.ogg",1)
EndFunction

'===============================================================================
'
'===============================================================================