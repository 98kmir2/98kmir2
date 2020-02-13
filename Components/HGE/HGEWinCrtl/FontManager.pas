unit FontManager;

interface
    uses
      Windows,Classes,HGETTF,TTFFontApi;
type
 TFontManager  = class
	  mLibrary     :Pointer;
	  mInitialized :Boolean;
	  mFontList    :TList;
 public
   constructor Create();virtual;
   destructor Destroy; override;

   function Initialize():Boolean;
   function isInitialized():Boolean;

   function  loadFont(Filename :string):Boolean;
   function  isFontLoaded(Filename:string):Boolean;
   procedure unloadFont(Filename:string);
   procedure unloadFonts();
   function  getFont(Filename:string):TTFFont;


  private


 end;



implementation


{ TFontManager }
constructor TFontManager.Create;
begin
   inherited Create;
   mFontList    :=TList.Create;
   mLibrary     :=nil;
   mInitialized :=false
end;

destructor TFontManager.Destroy;
begin
	unloadFonts();
	if (mInitialized) then
	  	C_FT_Done_FreeType(mLibrary);
  inherited;
end;

function TFontManager.Initialize: Boolean;
begin
	if (isInitialized()) then begin
		Result := true;
    Exit;
  end;
	if (C_FT_Init_FreeType(mLibrary) <> 0) then begin
		Result := false;
    Exit;
  end;
	mInitialized := true;
	Result := true;
end;

function TFontManager.loadFont(Filename: string): Boolean;
var
  newFont    :TTFFont;
begin
	if (not isInitialized()) then begin
		Result := false;
    Exit;
  end;

	if (isFontLoaded(Filename)) then begin
		Result  := true;
    Exit;
  end;


	newFont  := TTFFont.Create(mLibrary);
	if (not newFont.Load(Filename)) then begin
		newFont.Free;
		Result := false;
  end;
  mFontList.Add(newFont);
	Result := true;
end;

procedure TFontManager.unloadFont(Filename: string);
var
  I        :Integer;
  theFont  :TTFFont;
begin
	if (not isInitialized()) then Exit;
  for I := 0 to mFontList.Count - 1 do begin
     theFont  :=  TTFFont(mFontList[I]);
     if (theFont <> nil) and (theFont.getFilename = Filename) then begin
       theFont.Unload;
       mFontList.Delete(I);
       theFont.Free;
     end;
  end;
end;

procedure TFontManager.unloadFonts;
var
  I        :Integer;
  theFont  :TTFFont;
begin
	if (not isInitialized()) then Exit;
  for I := 0 to mFontList.Count - 1 do begin
     theFont  :=  TTFFont(mFontList[I]);
     if (theFont <> nil)  then begin
       theFont.Unload;
       theFont.Free;
     end;
     mFontList.Delete(I);
  end;
end;


function TFontManager.getFont(Filename: string): TTFFont;
var
  I        :Integer;
  theFont  :TTFFont;
begin
	if (not isInitialized()) or not isFontLoaded(Filename) then begin
		Result := nil;
    Exit;
  end;
  for I := 0 to mFontList.Count - 1 do begin
     theFont  :=  TTFFont(mFontList[I]);
     if (theFont <> nil) and (theFont.getFilename = Filename) then begin
       Result :=  theFont;
     end;
  end;
end;



function TFontManager.isFontLoaded(Filename: string): Boolean;
var
  I        :Integer;
  theFont  :TTFFont;
begin
  Result := False;
  for I := 0 to mFontList.Count - 1 do begin
     theFont  :=  TTFFont(mFontList[I]);
     if (theFont <> nil) and (theFont.getFilename = Filename) then begin
       Result :=  True;
     end;
  end;
end;

function TFontManager.isInitialized: Boolean;
begin
  Result := mInitialized;
end;






end.
