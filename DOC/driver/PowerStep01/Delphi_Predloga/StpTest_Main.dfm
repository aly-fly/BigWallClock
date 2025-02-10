object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 311
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 3
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 196
    Top = 112
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object BtnLoadParam: TButton
    Left = 16
    Top = 133
    Width = 109
    Height = 25
    Caption = 'Nalo'#382'i konfiguracijo'
    TabOrder = 0
    OnClick = BtnLoadParamClick
  end
  object Button2: TButton
    Left = 16
    Top = 184
    Width = 120
    Height = 25
    Caption = 'Run'
    TabOrder = 1
    OnClick = Button2Click
  end
  object EdStpSpeed: TEdit
    Left = 148
    Top = 186
    Width = 69
    Height = 21
    TabOrder = 2
    Text = '100'
  end
  object Button3: TButton
    Left = 16
    Top = 213
    Width = 120
    Height = 25
    Caption = 'HI Z'
    TabOrder = 3
    OnClick = Button3Click
  end
  object BtnClearStatus: TButton
    Left = 16
    Top = 242
    Width = 120
    Height = 25
    Caption = 'Clear status'
    TabOrder = 4
    OnClick = BtnClearStatusClick
  end
  object RgMotor: TRadioGroup
    Left = 16
    Top = 22
    Width = 125
    Height = 105
    Caption = 'Motor'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 184
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Position'
    TabOrder = 6
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    Left = 176
    Top = 8
  end
end
