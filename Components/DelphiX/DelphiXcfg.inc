{$B-,J+,Q-,R-,T-,X+}

{$IFDEF VER100}
  {$DEFINE VER3UP}
{$ELSE}
  {$IFDEF VER120}
    {$DEFINE VER4UP}
    {$DEFINE VER3UP}
  {$ELSE}
    {$IFDEF VER130}
      {$DEFINE VER3UP}
      {$DEFINE VER4UP}
      {$DEFINE VER5UP}
    {$ELSE}
      {$IFDEF VER140}
        {$DEFINE VER3UP}
        {$DEFINE VER4UP}
        {$DEFINE VER5UP}
        {$DEFINE VER6UP}
      {$ELSE}
        {$IFDEF VER150}
          {$DEFINE VER3UP}
          {$DEFINE VER4UP}
          {$DEFINE VER5UP}
          {$DEFINE VER6UP}
          {$DEFINE VER7UP}
        {$ELSE}
          {$IFDEF VER170}
            {$DEFINE VER3UP}
            {$DEFINE VER4UP}
            {$DEFINE VER5UP}
            {$DEFINE VER6UP}
            {$DEFINE VER7UP}
            {$DEFINE VER9UP}
          {$ELSE}
            {$IFDEF VER180}
              {$DEFINE VER3UP}
              {$DEFINE VER4UP}
              {$DEFINE VER5UP}
              {$DEFINE VER6UP}
              {$DEFINE VER7UP}
              {$DEFINE VER9UP}
              {$DEFINE VER10UP}
            {$ELSE}
              {$IFDEF VER185}
                {$DEFINE VER3UP}
                {$DEFINE VER4UP}
                {$DEFINE VER5UP}
                {$DEFINE VER6UP}
                {$DEFINE VER7UP}
                {$DEFINE VER9UP}
                {$DEFINE VER10UP}
                {$DEFINE VER11UP}
              {$ELSE}
                {$DEFINE VER3UP}
                {$DEFINE VER4UP}
                {$DEFINE VER5UP}
                {$DEFINE VER6UP}
                {$DEFINE VER7UP}
                {$DEFINE VER9UP}
                {$DEFINE VER10UP}
                {$DEFINE VER11UP}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER100}
  // Delphi 3
  {$DEFINE DelphiX_Delphi3}
  {$Define D3UP}
{$ENDIF}

{$IFDEF VER120}
  // Delphi 4
  {$DEFINE DelphiX_Delphi4}
  {$Define D3UP}
  {$Define D4UP}
{$ENDIF}

{$IFDEF VER130}
  // Delphi 5
  {$DEFINE DelphiX_Delphi5}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
{$ENDIF}

{$IFDEF VER140}
  // Delphi 6
  {$DEFINE DelphiX_Delphi6}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
{$ENDIF}

{$IFDEF VER150}
  // Delphi 7
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
{$ENDIF}

{$IFDEF VER170}
  // Delphi 9 - 2005
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$DEFINE DelphiX_Delphi9} //2005
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
  {$Define D9UP}
{$ENDIF}

{$IFDEF VER180}
  // Delphi 10 - 2006 or Turbo
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$DEFINE DelphiX_Delphi9}  //2005
  {$DEFINE DelphiX_Delphi10} //2006 or Turbo
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
  {$Define D9UP}
  {$Define D10UP}
{$ENDIF}

{$IFDEF VER185}
  // Delphi 11 - 2007
  {$DEFINE DelphiX_Delphi6}
  {$DEFINE DelphiX_Delphi7}
  {$DEFINE DelphiX_Delphi9}  //2005
  {$DEFINE DelphiX_Delphi10} //2006 or Turbo
  {$DEFINE DelphiX_Delphi11} //2007
  {$Define D3UP}
  {$Define D4UP}
  {$Define D5UP}
  {$Define D6UP}
  {$Define D7UP}
  {$Define D9UP}
  {$Define D10UP}
  {$Define D11UP}
{$ENDIF}

{$IFDEF DelphiX_Delphi3}
  {$DEFINE DelphiX_Spt3}
{$ENDIF}

{$IFDEF DelphiX_Delphi4}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
{$ENDIF}

{$IFDEF DelphiX_Delphi5}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
{$ENDIF}

{$IFDEF DelphiX_Delphi6}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
{$ENDIF}

{$IFDEF DelphiX_Delphi7}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
{$ENDIF}

{$IFDEF DelphiX_Delphi9}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
  {$DEFINE DelphiX_Spt9}
{$ENDIF}

{$IFDEF DelphiX_Delphi10}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
  {$DEFINE DelphiX_Spt9}
  {$DEFINE DelphiX_Spt10}
{$ENDIF}

{$IFDEF DelphiX_Delphi11}
  {$DEFINE DelphiX_Spt3}
  {$DEFINE DelphiX_Spt4}
  {$DEFINE DelphiX_Spt5}
  {$DEFINE DelphiX_Spt6}
  {$DEFINE DelphiX_Spt7}
  {$DEFINE DelphiX_Spt9}
  {$DEFINE DelphiX_Spt10}
  {$DEFINE DelphiX_Spt11}
{$ENDIF}

{this class is deprecated; when you can it use, change dot bellow}
{.$Define DX3D_deprecated}

{.$Define DrawHWAcc}

{DirectX Double precision activation}
{.$DEFINE DXDOUBLEPRECISION}

{Only one can be set!}
{Use standard of DirectX version 7}
{$DEFINE DX7}
{Use standard of DirectX version 9}
{.$DEFINE DX9}


{when you can use this option, you must use separate unit}
{if this turn off, you use built-in standard DirectX.pas unit}
{.$DEFINE StandardDX}


{for better texture compression can be use ZLIB here}
{.$DEFINE DXTextureImage_UseZLIB}

{$IfDef DX7}
{Retained mode is turn off for Vista as implicit value}
  {.$Define D3DRM}
{$EndIf}