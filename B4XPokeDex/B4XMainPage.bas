B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=B4XPokeDex.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private B4XImageView1 As B4XImageView
	Private B4XFloatTextField1 As B4XFloatTextField
	Private Button1 As B4XView
	Private Label1 As B4XView
	Private Label2 As B4XView
End Sub

Public Sub Initialize

End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	B4XPages.SetTitle(Me, "B4XPokeDex")
	B4XFloatTextField1.Text = "mewtwo"
	B4XFloatTextField1.RequestFocusAndShowKeyboard
End Sub

Private Sub Button1_Click
	FindPokemon (B4XFloatTextField1.Text)
End Sub

Sub FindPokemon (Find As String)
	If Find = "" Then Return
	Try
		Dim j As HttpJob
		j.Initialize("", Me)
		j.Download($"https://pokeapi.co/api/v2/pokemon/${Find.ToLowerCase}"$)
		Wait For (j) JobDone (j As HttpJob)
		If j.Success Then
			Dim Res As Map = j.GetString.As(JSON).ToMap
			Dim image As String = Res.Get("sprites").As(Map).Get("front_default")
			Dim PokemonType As String = Res.Get("types").As(List).Get(0).As(Map).Get("type").As(Map).Get("name")
			DownloadAndSetImage(image)
			Label1.Text = Find.ToUpperCase
			Label2.Text = PokemonType
		Else
			Log(j.ErrorMessage)
		End If
	Catch
		Log(LastException)
	End Try
	j.Release
End Sub

Sub DownloadAndSetImage(Url As String)
	Try
		Dim j As HttpJob
		j.Initialize("", Me)
		j.Download(Url)
		Wait For (j) JobDone (j As HttpJob)
		If j.Success Then
			B4XImageView1.Bitmap = j.GetBitmap
		End If
	Catch
		Log(LastException)
	End Try
	j.Release
End Sub
