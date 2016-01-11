Strict
Import MaxGui.Drivers

AppTitle = "BigSearch"

Const Views = 1'3 ' Update this if you add more searches in DefData lines below!

Global HTML:TGadget [Views]

Global HTMLTitle$ [Views]
Global HTMLURL$ [Views]

Global gadheight = 24

For Local site = 0 To Views - 1
	ReadData HTMLTitle[site]
	ReadData HTMLURL[site]
Next

' Some random examples...

'DefData "Google", "http://www.google.com/search?q="
'DefData "Yahoo", "http://search.yahoo.com/search?p="
DefData "Merriam-Webster Dictionary", "http://www.m-w.com/cgi-bin/dictionary?"

Global Load:TStream = ReadFile ("window.dat")
Global x, y, width, height
If Load
	x = Int (ReadLine (Load))
	y = Int (ReadLine (Load))
	width = Int (ReadLine (Load))
	height = Int (ReadLine (Load))
EndIf

If x < 0 Then x = 0
If x > GadgetWidth (Desktop ()) x = 0

If y < 0 Then x = 0
If y > GadgetHeight (Desktop ()) x = 0

If width <= 0 width = 640
If height <= 0 height = 480

Global window:TGadget = CreateWindow ("BigSearch", x, y, width, height)

Global htmlheight = (ClientHeight (window) - gadheight) / Views

If window

	Local file:TGadget = CreateMenu ("&File", 0, WindowMenu (window))
	Local xit:TGadget = CreateMenu ("E&xit", 1, file)

	Local help:TGadget = CreateMenu ("&Help", 2, WindowMenu (window))
	Local about:TGadget = CreateMenu ("&About...", 3, help)

	UpdateWindowMenu window
	
	Local search:TGadget = CreateTextField (4, 4, ClientWidth (window) - 152, gadheight, window)

	Local go:TGadget = CreateButton ("Search!", ClientWidth (window) - 144, 4, 140, gadheight, window, BUTTON_OK)

	SetGadgetLayout search, 1, 1, 1, 0
	SetGadgetLayout go, 0, 1, 1, 0

	Local tab:TGadget = CreateTabber (0, gadheight+4, ClientWidth (window), ClientHeight (window) - gadheight - 4, window)	
	Local panel:TGadget = CreatePanel (0, 0, ClientWidth (tab), ClientHeight (tab), tab)

	SetGadgetLayout tab, 1, 1, 1, 1
	SetGadgetLayout panel, 1, 1, 1, 1
	
	Local HTML:TGadget[Views-1]
	
	For Local loop:Int = 0 To Views - 1
		HTML[loop] = CreateHTMLView (0, 0, ClientWidth (panel), ClientHeight (panel), panel)
		SetGadgetLayout HTML[loop], 1, 1, 1, 1
		HideGadget HTML[loop]
		AddGadgetItem (tab, HTMLTitle[loop])
	Next
	
	ShowGadget HTML[0]
	SetStatusText window, "Done"
	
	Local urltimer:TTimer = CreateTimer (1)
	
	ActivateGadget search
	
	Repeat

		Select WaitEvent ()
'		Print currentevent.toString()
'		Select EventID()

			Case EVENT_GADGETACTION
				If (EventSource () = go)' Or ((EventSource () = search) And (EventData () = KEY_ENTER))
					For Local site = 0 To Views - 1
						HtmlViewGo HTML[site], HTMLURL[site] + TextFieldText (search)
					Next
				EndIf

				If EventSource () = tab
					For Local loop = 0 To Views - 1
						HideGadget HTML[loop]
					Next
					ShowGadget HTML[ SelectedGadgetItem (tab) ]
					ActivateGadget HTML[ SelectedGadgetItem (tab) ]
				EndIf
				
			Case EVENT_WINDOWCLOSE
				SaveWindow (window); End

' ****** Not working!

			Case EVENT_TIMERTICK
'			DebugLog HtmlViewStatus (HTML (SelectedGadgetItem (tab)))
					If HtmlViewStatus (HTML[ SelectedGadgetItem (tab) ]) 
						SetStatusText window, "Loading..."
					Else
						SetStatusText window, "Done"
					EndIf

'			Case EVENT_GADGETDONE
'			DebugLog HtmlViewStatus (HTML (SelectedGadgetItem (tab)))
						
			Case EVENT_MENUACTION
				If EventData () = 1 Then SaveWindow (window); End
				If EventData () = 3 Then Notify ("BigSearch: it searches [tm]")
			
		End Select
		
	Forever
	
EndIf

Function SaveWindow (window:TGadget)
	If window
		Local save:TStream = WriteFile ("window.dat")
		If save
			WriteLine save, GadgetX (window)
			WriteLine save, GadgetY (window)
			WriteLine save, GadgetWidth (window)
			WriteLine save, GadgetHeight (window)
			CloseFile save
		EndIf
	EndIf
End Function

