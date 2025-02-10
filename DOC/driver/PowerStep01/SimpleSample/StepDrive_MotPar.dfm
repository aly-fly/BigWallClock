object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 650
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button3: TButton
    Left = 336
    Top = 20
    Width = 89
    Height = 25
    Caption = 'Shrani'
    TabOrder = 0
    OnClick = Button3Click
  end
  object EdMotorModel: TEdit
    Left = 14
    Top = 22
    Width = 185
    Height = 21
    TabOrder = 1
    Text = '17HS13-0404S'
    OnChange = EdMotorModelChange
    OnKeyPress = EdMotorModelKeyPress
  end
  object Button18: TButton
    Left = 205
    Top = 20
    Width = 44
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button18Click
  end
end
