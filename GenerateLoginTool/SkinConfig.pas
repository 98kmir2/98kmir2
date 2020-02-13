unit SkinConfig;

interface

type

  RadioConf = record
    Left: Word;
    Top: Word;
    bWindow: Boolean;
  end;

  LabelConf = record
    Left: Word;
    Top: Word;
  end;
  pLabelConf = ^LabelConf;

  PanelConf = record
    Left: Word;
    Top: Word;
    Width: Word;
    Height: Word;
  end;
  pPanelConf = ^PanelConf;

  BtnConf = record
    Left: Word;
    Top: Word;
    Width: Word;
    Height: Word;
    bShow: Boolean;
  end;
  pBtnConf = ^BtnConf;


implementation

end.
