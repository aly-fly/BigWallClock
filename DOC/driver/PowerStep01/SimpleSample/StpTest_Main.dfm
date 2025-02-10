object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Pogon kora'#269'nega motorja'
  ClientHeight = 266
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 16
    Top = 46
    Width = 29
    Height = 31
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '<'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 119
    Top = 47
    Width = 29
    Height = 32
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '>'
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 17
    Top = 84
    Width = 58
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Pomik 1 ( '#176' )'
  end
  object Label7: TLabel
    Left = 89
    Top = 84
    Width = 58
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Pomik 2 ( '#176' )'
  end
  object Label3: TLabel
    Left = 16
    Top = 7
    Width = 67
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Hitrost (stp/s)'
  end
  object Label8: TLabel
    Left = 220
    Top = 77
    Width = 86
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = 'Pospe'#353'ek (stp/s2)'
    Visible = False
  end
  object Label9: TLabel
    Left = 222
    Top = 37
    Width = 83
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Korakov na obrat'
    Visible = False
  end
  object sbVecManj: TSpeedButton
    Left = 168
    Top = 7
    Width = 37
    Height = 17
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Ve'#269' >'
    OnClick = sbVecManjClick
  end
  object BtnLoadParam: TButton
    Left = 215
    Top = 7
    Width = 106
    Height = 25
    Caption = 'Nalo'#382'i konfiguracijo'
    TabOrder = 0
    Visible = False
    OnClick = BtnLoadParamClick
  end
  object BtnClearStatus: TButton
    Left = 44
    Top = 192
    Width = 70
    Height = 25
    Caption = 'Zbri'#353'i status'
    TabOrder = 1
    OnClick = BtnClearStatusClick
  end
  object btnStop: TButton
    Left = 56
    Top = 46
    Width = 50
    Height = 31
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Stop'
    Default = True
    TabOrder = 2
    OnClick = btnStopClick
  end
  object btnCikel: TButton
    Left = 16
    Top = 125
    Width = 133
    Height = 37
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Start motorja in snemanja'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    WordWrap = True
    OnClick = btnCikelClick
  end
  object Edit1: TEdit
    Left = 17
    Top = 98
    Width = 42
    Height = 21
    Hint = 'Pomik 1 v lo'#269'nih stopinjah'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = '450'
  end
  object Edit2: TEdit
    Left = 89
    Top = 98
    Width = 43
    Height = 21
    Hint = 'Pomik 2 v lo'#269'nih stopinjah'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '-90'
  end
  object udNaprej: TUpDown
    Left = 59
    Top = 98
    Width = 16
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Associate = Edit1
    Min = -3600
    Max = 3600
    Position = 450
    TabOrder = 6
    Thousands = False
  end
  object udNazaj: TUpDown
    Left = 132
    Top = 98
    Width = 15
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Associate = Edit2
    Min = -3600
    Max = 3600
    Position = -90
    TabOrder = 7
    Thousands = False
  end
  object seHitrost: TSpinEdit
    Left = 17
    Top = 20
    Width = 52
    Height = 22
    Hint = 'ciljna hitrost'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    MaxValue = 20000
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Value = 200
  end
  object cbKratNicCelaEna: TCheckBox
    Left = 72
    Top = 24
    Width = 73
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'x 0.1'
    TabOrder = 9
  end
  object seStKorakovNaObrat: TSpinEdit
    Left = 222
    Top = 52
    Width = 76
    Height = 22
    Hint = 'Stevilo polov / korakov na obrat'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    MaxValue = 200000
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Value = 153600
    Visible = False
  end
  object sePospesek: TSpinEdit
    Left = 222
    Top = 92
    Width = 76
    Height = 22
    Hint = 'pospesek'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    MaxValue = 5000
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    Value = 50
    Visible = False
  end
  object cbPodporaAksIMDebug: TCheckBox
    Left = 222
    Top = 117
    Width = 84
    Height = 28
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Podpora AksIM Debug'
    Checked = True
    State = cbChecked
    TabOrder = 12
    Visible = False
    WordWrap = True
    OnClick = cbPodporaAksIMDebugClick
  end
  object cbEnableControl: TCheckBox
    Left = 222
    Top = 150
    Width = 84
    Height = 28
    Hint = 
      #268'e je to polje potrjeno, se Enable vklju'#269'i ok kliku gumba SNEMAJ' +
      '... in se izklju'#269'i po koncu snemanja'
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Avtomatsko vklju'#269'i Enable '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Visible = False
    WordWrap = True
  end
  object pnlEnabled: TPanel
    Left = 44
    Top = 166
    Width = 70
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Enabled'
    TabOrder = 14
    OnClick = pnlEnabledClick
  end
  object StBar0: TStatusBar
    Left = 0
    Top = 244
    Width = 417
    Height = 26
    Align = alNone
    DoubleBuffered = True
    Panels = <
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 40
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 60
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 90
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 70
      end>
    ParentDoubleBuffered = False
    SizeGrip = False
    OnDblClick = StBar0DblClick
    OnDrawPanel = StBar0DrawPanel
  end
  object stBar1: TStatusBar
    Left = 0
    Top = 218
    Width = 417
    Height = 26
    Align = alNone
    DoubleBuffered = True
    Panels = <
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 50
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 40
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 40
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 30
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 65
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 50
      end
      item
        Alignment = taCenter
        Style = psOwnerDraw
        Width = 60
      end>
    ParentDoubleBuffered = False
    SizeGrip = False
    Visible = False
    OnDrawPanel = stBar1DrawPanel
  end
  object cbPonavljaj: TCheckBox
    Left = 222
    Top = 191
    Width = 97
    Height = 17
    Caption = 'Ponavljaj premik'
    TabOrder = 17
    OnClick = cbPonavljajClick
  end
  object OpenDialog1: TOpenDialog
    Left = 124
  end
  object LoopTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = LoopTimerTimer
    Left = 164
    Top = 4
  end
end
