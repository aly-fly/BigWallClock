object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 945
  ClientWidth = 1061
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1061
    Height = 945
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object TabCnOs: TTabControl
      Left = 0
      Top = 35
      Width = 1061
      Height = 796
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      MultiLine = True
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
      Tabs.Strings = (
        '1')
      TabIndex = 0
      OnChange = TabCnOsChange
      object PageControl1: TPageControl
        Left = 4
        Top = 29
        Width = 1053
        Height = 763
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ActivePage = TbShUkazi
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        MultiLine = True
        ParentFont = False
        TabOrder = 0
        object TbShUkazi: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Ukazi'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ImageIndex = 2
          ParentFont = False
          object PnlPwrKomande: TPanel
            Left = 0
            Top = 245
            Width = 340
            Height = 482
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            object Label4: TLabel
              Left = 10
              Top = 10
              Width = 114
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Run with speed'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 10
              Top = 158
              Width = 126
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Move for N steps'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label7: TLabel
              Left = 10
              Top = 187
              Width = 102
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'GoTo position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label8: TLabel
              Left = 10
              Top = 41
              Width = 143
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'GoTo Sw, set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label9: TLabel
              Left = 10
              Top = 98
              Width = 165
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Release Sw, set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label10: TLabel
              Left = 10
              Top = 279
              Width = 41
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'STOP'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label12: TLabel
              Left = 10
              Top = 247
              Width = 39
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Go to'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label18: TLabel
              Left = 10
              Top = 310
              Width = 95
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Driver in HiZ'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label14: TLabel
              Left = 10
              Top = 69
              Width = 170
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'GoTo Sw, preset MARK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label32: TLabel
              Left = 10
              Top = 128
              Width = 192
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Release Sw, preset MARK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label33: TLabel
              Left = 10
              Top = 217
              Width = 102
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'GoTo position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label38: TLabel
              Left = 10
              Top = 340
              Width = 107
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Reset position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label44: TLabel
              Left = 10
              Top = 370
              Width = 127
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Device soft reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label1: TLabel
              Left = 10
              Top = 400
              Width = 132
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Device hard reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BtnPwr_RunFw: TButton
              Left = 267
              Top = 7
              Width = 59
              Height = 27
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = BtnPwr_RunFwClick
            end
            object BtnPwr_MoveFw: TButton
              Left = 267
              Top = 154
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              OnClick = BtnPwr_MoveFwClick
            end
            object BtnPwr_GoTo: TButton
              Left = 207
              Top = 213
              Width = 119
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'SHORT'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              OnClick = BtnPwr_GoToClick
            end
            object BtnPwr_GoToDirFwd: TButton
              Left = 267
              Top = 183
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              OnClick = BtnPwr_GoToDirFwdClick
            end
            object BtnPwr_GoUntil_dFwd: TButton
              Left = 267
              Top = 37
              Width = 59
              Height = 27
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 10
              OnClick = BtnPwr_GoUntil_dFwdClick
            end
            object BtnPwr_GoHome: TButton
              Left = 267
              Top = 243
              Width = 59
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              OnClick = BtnPwr_GoHomeClick
            end
            object BtnPwr_GoMark: TButton
              Left = 207
              Top = 243
              Width = 58
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Mark'
              TabOrder = 7
              OnClick = BtnPwr_GoMarkClick
            end
            object BtnPwr_ResetPos: TButton
              Left = 207
              Top = 336
              Width = 119
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 17
              OnClick = BtnPwr_ResetPosClick
            end
            object BtnPwr_ResetDevice: TButton
              Left = 207
              Top = 366
              Width = 119
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Device Reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 18
              OnClick = BtnPwr_ResetDeviceClick
            end
            object BtnPwr_SoftStop: TButton
              Left = 207
              Top = 275
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Soft'
              TabOrder = 13
              OnClick = BtnPwr_SoftStopClick
            end
            object BtnPwr_HardStop: TButton
              Left = 267
              Top = 275
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Hard'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              OnClick = BtnPwr_HardStopClick
            end
            object BtnPwr_SoftHiZ: TButton
              Left = 207
              Top = 306
              Width = 58
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Soft'
              TabOrder = 15
              OnClick = BtnPwr_SoftHiZClick
            end
            object BtnPwr_HardHiZ: TButton
              Left = 267
              Top = 306
              Width = 59
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Hard'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = BtnPwr_HardHiZClick
            end
            object BtnPwr_RunBck: TButton
              Left = 207
              Top = 7
              Width = 58
              Height = 27
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = BtnPwr_RunBckClick
            end
            object BtnPwr_MoveBck: TButton
              Left = 207
              Top = 154
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = BtnPwr_MoveBckClick
            end
            object BtnPwr_GoToDirBck: TButton
              Left = 207
              Top = 183
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = BtnPwr_GoToDirBckClick
            end
            object BtnPwr_GoUntil_dBck: TButton
              Left = 207
              Top = 37
              Width = 58
              Height = 27
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
              OnClick = BtnPwr_GoUntil_dBckClick
            end
            object BtnPwr_ReleseSW_dFwd: TButton
              Left = 267
              Top = 94
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              OnClick = BtnPwr_ReleseSW_dFwdClick
            end
            object BtnPwr_ReleseSW_dBck: TButton
              Left = 207
              Top = 94
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
              OnClick = BtnPwr_ReleseSW_dBckClick
            end
            object Button2: TButton
              Left = 10
              Top = 430
              Width = 316
              Height = 45
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Hi Z'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -23
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 19
              OnClick = Button2Click
            end
            object Button13: TButton
              Left = 207
              Top = 65
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 20
              OnClick = Button13Click
            end
            object Button14: TButton
              Left = 267
              Top = 65
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 21
              OnClick = Button14Click
            end
            object Button15: TButton
              Left = 207
              Top = 124
              Width = 58
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 22
              OnClick = Button15Click
            end
            object Button16: TButton
              Left = 267
              Top = 124
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 23
              OnClick = Button16Click
            end
            object BtnHwReset: TButton
              Left = 207
              Top = 396
              Width = 119
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Device reset'
              TabOrder = 24
              OnClick = BtnHwResetClick
            end
          end
          object PnlPwrGibParam: TPanel
            Left = 0
            Top = 0
            Width = 340
            Height = 95
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            object Label17: TLabel
              Left = 10
              Top = 10
              Width = 55
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label34: TLabel
              Left = 10
              Top = 39
              Width = 70
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Position :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label35: TLabel
              Left = 10
              Top = 68
              Width = 65
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'N steps :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label36: TLabel
              Left = 192
              Top = 10
              Width = 33
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object EdStpNstep: TEdit
              Left = 101
              Top = 64
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '1000'
            end
            object EdStpSpeed: TEdit
              Left = 101
              Top = 7
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '1000'
            end
            object EdStpAbsPos: TEdit
              Left = 101
              Top = 35
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 2
              Text = '1000'
            end
            object CbCiguMigu: TCheckBox
              Left = 239
              Top = 72
              Width = 98
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Move cyclic'
              TabOrder = 3
              OnClick = CbCiguMiguClick
            end
          end
          object PnlPwrGibParam2: TPanel
            Left = 0
            Top = 94
            Width = 340
            Height = 153
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            object Label39: TLabel
              Left = 10
              Top = 67
              Width = 70
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Acceler. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label40: TLabel
              Left = 10
              Top = 95
              Width = 72
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Deceler. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label41: TLabel
              Left = 192
              Top = 67
              Width = 40
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'stp/s'#178
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label42: TLabel
              Left = 192
              Top = 94
              Width = 40
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'stp/s'#178
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label43: TLabel
              Left = 10
              Top = 9
              Width = 88
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Max speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label46: TLabel
              Left = 192
              Top = 9
              Width = 33
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label47: TLabel
              Left = 10
              Top = 38
              Width = 84
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Min speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label48: TLabel
              Left = 192
              Top = 38
              Width = 33
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 10
              Top = 124
              Width = 82
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Mark pos. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object EdStpAcceleration: TEdit
              Left = 101
              Top = 63
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '10'
            end
            object EdStpDeceleration: TEdit
              Left = 101
              Top = 92
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '10'
            end
            object EdStpMaxSpeed: TEdit
              Left = 101
              Top = 5
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = '10'
            end
            object EdStpMinSpeed: TEdit
              Left = 101
              Top = 34
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = '10'
            end
            object BtnSetMovements: TButton
              Left = 267
              Top = 120
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'SET'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = BtnSetMovementsClick
            end
            object EdStpMarkPos: TEdit
              Left = 101
              Top = 120
              Width = 86
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Text = '10000'
            end
            object Button23: TButton
              Left = 267
              Top = 90
              Width = 59
              Height = 28
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'READ'
              TabOrder = 6
              OnClick = Button23Click
            end
          end
          object GroupBox_PwrClkSet: TGroupBox
            Left = 345
            Top = 0
            Width = 682
            Height = 473
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '>>>>>   K O N F I G U R A C I J E   <<<<<'
            Color = clCream
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentColor = False
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            object Label11: TLabel
              Left = 10
              Top = 170
              Width = 108
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Clock frequency:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label13: TLabel
              Left = 10
              Top = 200
              Width = 77
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'OscOut pin:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblConf_PwmTswN: TLabel
              Left = 348
              Top = 55
              Width = 123
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'LblConf_PwmTswN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblConf_PwmTswV: TLabel
              Left = 510
              Top = 55
              Width = 122
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'LblConf_PwmTswV'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 343
              Top = 201
              Width = 76
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Step mode:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label15: TLabel
              Left = 343
              Top = 231
              Width = 78
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Sync mode:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label27: TLabel
              Left = 343
              Top = 279
              Width = 92
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Gate current :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 343
              Top = 309
              Width = 152
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Constant current time :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label29: TLabel
              Left = 343
              Top = 339
              Width = 138
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Turn off boost time :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 343
              Top = 369
              Width = 72
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Dead time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 343
              Top = 399
              Width = 90
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Blanking time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblKval: TLabel
              Left = 341
              Top = 428
              Width = 35
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Tok: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object RgConf_ClkSrc: TRadioGroup
              Left = 4
              Top = 67
              Width = 316
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Clock source:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Internal'
                'External')
              ParentFont = False
              TabOrder = 0
              OnClick = RgConf_ClkSrcClick
            end
            object RgConf_ClkSrcType: TRadioGroup
              Left = 4
              Top = 114
              Width = 316
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'External source type:'
              Columns = 2
              DoubleBuffered = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Xtal/Reson.'
                'Direct')
              ParentDoubleBuffered = False
              ParentFont = False
              TabOrder = 1
              OnClick = RgConf_ClkSrcTypeClick
            end
            object CmbBConf_ClkFreq: TComboBox
              Left = 152
              Top = 165
              Width = 168
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnChange = CmbBConf_ClkFreqChange
              Items.Strings = (
                '  8 MHz'
                '16 MHz'
                '24 MHz'
                '32 MHz')
            end
            object CmbBConf_OscOut: TComboBox
              Left = 152
              Top = 195
              Width = 168
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              DoubleBuffered = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentDoubleBuffered = False
              ParentFont = False
              TabOrder = 3
              OnChange = CmbBConf_OscOutChange
              Items.Strings = (
                ' 2 MHz '
                ' 4 MHz'
                ' 8 MHz'
                '16 MHz'
                'Unused'
                'Oscilator driving'
                'Inv. OSCIN out')
            end
            object CmbBConf_WD_EN: TCheckBox
              Left = 10
              Top = 229
              Width = 312
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Enable controller reset at clock error detection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = CmbBConf_WD_ENClick
            end
            object RgConf_ExtSW: TRadioGroup
              Left = 4
              Top = 258
              Width = 316
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'External switch mode:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Motor hard STOP'
                'Indication only')
              ParentFont = False
              TabOrder = 5
              OnClick = RgConf_ExtSWClick
            end
            object CmbBConf_BridgOff: TCheckBox
              Left = 10
              Top = 314
              Width = 263
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Turn off bridges at overcurrent'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              OnClick = CmbBConf_BridgOffClick
            end
            object RgConf_VccVolt: TRadioGroup
              Left = 5
              Top = 343
              Width = 317
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Vcc voltage regulator value:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                '7,5 V'
                '15 V')
              ParentFont = False
              TabOrder = 7
              OnClick = RgConf_VccVoltClick
            end
            object RgConf_UVLO: TRadioGroup
              Left = 4
              Top = 391
              Width = 316
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Undervoltage treshold settings:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                '6,3 /6,9 /5,5 /6 V'
                '10 /10,4 /8,8 /9,2 V')
              ParentFont = False
              TabOrder = 8
              OnClick = RgConf_UVLOClick
            end
            object CmbBConf_Bit5: TCheckBox
              Left = 343
              Top = 25
              Width = 290
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'CmbBConf_Bit5'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
              OnClick = CmbBConf_Bit5Click
            end
            object TbConfigPwmTsw: TTrackBar
              Left = 336
              Top = 72
              Width = 317
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Max = 100
              Position = 80
              ShowSelRange = False
              TabOrder = 10
              ThumbLength = 18
              TickStyle = tsNone
              OnChange = TbConfigPwmTswChange
            end
            object CmbBConf_PredEn: TCheckBox
              Left = 5
              Top = 441
              Width = 216
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Predictive current control'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
              OnClick = CmbBConf_PredEnClick
            end
            object CbAl_7: TCheckBox
              Left = 343
              Top = 102
              Width = 157
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Command error'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              OnClick = CbAl_7Click
            end
            object CbAl_6: TCheckBox
              Left = 343
              Top = 122
              Width = 157
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Switch turn-on event'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 13
              OnClick = CbAl_6Click
            end
            object CbAl_5: TCheckBox
              Left = 343
              Top = 141
              Width = 157
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Stall detection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              OnClick = CbAl_5Click
            end
            object CbAl_4: TCheckBox
              Left = 343
              Top = 161
              Width = 157
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'ADC UVLO'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 15
              OnClick = CbAl_4Click
            end
            object CbAl_3: TCheckBox
              Left = 503
              Top = 102
              Width = 151
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'UVLO'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = CbAl_3Click
            end
            object CbAl_2: TCheckBox
              Left = 503
              Top = 122
              Width = 151
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Thermal warning'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 17
              OnClick = CbAl_2Click
            end
            object CbAl_1: TCheckBox
              Left = 503
              Top = 141
              Width = 151
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Thermal shutdown'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 18
              OnClick = CbAl_1Click
            end
            object CbAl_0: TCheckBox
              Left = 503
              Top = 161
              Width = 151
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Overcurrent'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 19
              OnClick = CbAl_0Click
            end
            object RgPwrConfMode: TRadioGroup
              Left = 4
              Top = 21
              Width = 316
              Height = 48
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Operation mode:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Voltage'
                'Current')
              ParentFont = False
              TabOrder = 20
              OnClick = RgPwrConfModeClick
            end
            object CmbBConf_StepM: TComboBox
              Left = 497
              Top = 197
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 7
              ParentFont = False
              TabOrder = 21
              Text = '1/128 '#181'Step'
              OnChange = CmbBConf_StepMChange
              Items.Strings = (
                'Full-step'
                'Half-step'
                '1/4 '#181'Step'
                '1/8 '#181'Step'
                '1/16 '#181'Step'
                '1/32 '#181'Step'
                '1/64 '#181'Step'
                '1/128 '#181'Step')
            end
            object CmbBConf_SyncM: TComboBox
              Left = 498
              Top = 233
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 6
              ParentFont = False
              TabOrder = 22
              Text = '1/32 '#181'Step'
              OnChange = CmbBConf_SyncMChange
              Items.Strings = (
                'Disabled'
                'Full-step'
                'Half-step'
                '1/4 '#181'Step'
                '1/8 '#181'Step'
                '1/16 '#181'Step'
                '1/32 '#181'Step'
                '1/64 '#181'Step'
                '1/128 '#181'Step')
            end
            object CmbBConf_LowSpeedOpt: TCheckBox
              Left = 123
              Top = 441
              Width = 180
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Low speed optimisation'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 23
              OnClick = CmbBConf_LowSpeedOptClick
            end
            object CmbBConf_IGATE: TComboBox
              Left = 497
              Top = 275
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 24
              Text = ' 4 mA'
              OnChange = CmbBConf_IGATEChange
              Items.Strings = (
                ' 4 mA'
                ' 4 mA'
                ' 8 mA'
                '16 mA'
                '24 mA'
                '32 mA'
                '64 mA'
                '96 mA')
            end
            object CmbBConf_TCC: TComboBox
              Left = 497
              Top = 305
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 25
              Text = '125 ns'
              OnChange = CmbBConf_TCCChange
              Items.Strings = (
                '125 ns'
                '250 ns'
                '375 ns'
                '500 ns'
                '625 ns'
                '750 ns'
                '875 ns'
                '1000 ns'
                '1125 ns'
                '1250 ns'
                '1375 ns'
                '1500 ns'
                '1625 ns'
                '1750 ns'
                '1875 ns'
                '2000 ns'
                '2125 ns'
                '2250 ns'
                '2375 ns'
                '2500 ns'
                '2625 ns'
                '2750 ns'
                '2875 ns'
                '3000 ns'
                '3125 ns'
                '3250 ns'
                '3375 ns'
                '3500 ns'
                '3625 ns'
                '3750 ns'
                '3750 ns'
                '3750 ns')
            end
            object CmbBConf_TBOOST: TComboBox
              Left = 497
              Top = 335
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 26
              Text = '0 ns'
              OnChange = CmbBConf_TBOOSTChange
              Items.Strings = (
                '0 ns'
                '62,5 ns'
                '125 ns'
                '250 ns'
                '375 ns'
                '500 ns'
                '750 ns'
                '1000 ns')
            end
            object CmbBConf_TDT: TComboBox
              Left = 497
              Top = 365
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 27
              Text = '125 ns'
              OnChange = CmbBConf_TDTChange
              Items.Strings = (
                '125 ns'
                '250 ns'
                '375 ns'
                '500 ns'
                '625 ns'
                '750 ns'
                '875 ns'
                '1000 ns'
                '1125 ns'
                '1250 ns'
                '1375 ns'
                '1500 ns'
                '1625 ns'
                '1750 ns'
                '1875 ns'
                '2000 ns'
                '2125 ns'
                '2250 ns'
                '2375 ns'
                '2500 ns'
                '2625 ns'
                '2750 ns'
                '2875 ns'
                '3000 ns'
                '3125 ns'
                '3250 ns'
                '3375 ns'
                '3500 ns'
                '3625 ns'
                '3750 ns'
                '3875 ns'
                '4000 ns')
            end
            object CmbBConf_TBLANK: TComboBox
              Left = 497
              Top = 395
              Width = 156
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 28
              Text = '125 ns'
              OnChange = CmbBConf_TBLANKChange
              Items.Strings = (
                '125 ns'
                '250 ns'
                '375 ns'
                '500 ns'
                '625 ns'
                '750 ns'
                '875 ns'
                '1000 ns')
            end
            object TBarKval: TTrackBar
              Left = 339
              Top = 445
              Width = 332
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Max = 255
              Position = 127
              ShowSelRange = False
              TabOrder = 29
              ThumbLength = 18
              TickStyle = tsNone
              OnChange = TBarKvalChange
            end
          end
          object Panel2: TPanel
            Left = 348
            Top = 479
            Width = 454
            Height = 251
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 4
            object Label19: TLabel
              Left = 264
              Top = 58
              Width = 66
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Ke [V/Hz]'
            end
            object Label20: TLabel
              Left = 264
              Top = 86
              Width = 58
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'R [Ohm]'
            end
            object Label21: TLabel
              Left = 264
              Top = 116
              Width = 47
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'L [mH]'
            end
            object Label2: TLabel
              Left = 13
              Top = 10
              Width = 43
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Motor:'
            end
            object Label49: TLabel
              Left = 12
              Top = 47
              Width = 182
              Height = 18
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Uporabi privzete nastavitve:'
            end
            object EdKe: TEdit
              Left = 340
              Top = 52
              Width = 72
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Ctl3D = True
              ParentCtl3D = False
              TabOrder = 0
              Text = '0,023'
            end
            object EdRm: TEdit
              Left = 340
              Top = 82
              Width = 72
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 1
              Text = '5,9'
            end
            object EdLm: TEdit
              Left = 340
              Top = 112
              Width = 72
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 2
              Text = '4,2'
            end
            object CmbBoxMotorji: TComboBox
              Left = 63
              Top = 7
              Width = 239
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              DoubleBuffered = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentDoubleBuffered = False
              ParentFont = False
              Sorted = True
              TabOrder = 3
              OnChange = CmbBoxMotorjiChange
              Items.Strings = (
                '1'
                '1'
                '2'
                '2')
            end
            object BtnVoltageDefault: TButton
              Left = 8
              Top = 68
              Width = 104
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Voltage'
              TabOrder = 4
              OnClick = BtnVoltageDefaultClick
            end
            object BtnCurrentDefault: TButton
              Left = 120
              Top = 68
              Width = 105
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Current'
              TabOrder = 5
              OnClick = BtnCurrentDefaultClick
            end
            object BtnDodajMotor: TButton
              Left = 310
              Top = 5
              Width = 73
              Height = 29
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Dodaj'
              TabOrder = 6
              OnClick = BtnDodajMotorClick
            end
          end
          object PnlSaveLoad: TPanel
            Left = 809
            Top = 479
            Width = 218
            Height = 251
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 5
            object BtnSaveConfig: TButton
              Left = 14
              Top = 110
              Width = 79
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Shrani'
              TabOrder = 0
              OnClick = BtnSaveConfigClick
            end
            object BtnOpenConfig: TButton
              Left = 10
              Top = 13
              Width = 112
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Nalo'#382'i'
              TabOrder = 1
              OnClick = BtnOpenConfigClick
            end
            object BtnPwrBeriVse: TButton
              Left = 10
              Top = 48
              Width = 112
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Beri vse'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = BtnPwrBeriVseClick
            end
            object Button5: TButton
              Left = 14
              Top = 150
              Width = 81
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Edit'
              TabOrder = 3
              OnClick = Button5Click
            end
            object Button3: TButton
              Left = 16
              Top = 201
              Width = 98
              Height = 33
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Button3'
              TabOrder = 4
              OnClick = Button3Click
            end
          end
        end
        object TbShRegistri: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Registri'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          object StringGrid1: TStringGrid
            Left = 0
            Top = 0
            Width = 1063
            Height = 781
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ColCount = 9
            DefaultRowHeight = 20
            DoubleBuffered = True
            FixedCols = 0
            RowCount = 28
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goEditing]
            ParentDoubleBuffered = False
            ParentFont = False
            ScrollBars = ssNone
            TabOrder = 0
            OnDrawCell = StringGrid1DrawCell
            OnSetEditText = StringGrid1SetEditText
            OnTopLeftChanged = StringGrid1TopLeftChanged
            ColWidths = (
              64
              174
              64
              64
              64
              64
              64
              64
              64)
          end
        end
        object TbShMeilhaus: TTabSheet
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Merjenje'
          ImageIndex = 2
          object Label109: TLabel
            Left = 20
            Top = 5
            Width = 127
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Obmo'#269'je merjenja:'
          end
          object Label110: TLabel
            Left = 20
            Top = 281
            Width = 42
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Kanali:'
          end
          object Label111: TLabel
            Left = 20
            Top = 404
            Width = 137
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #268'as med kanali v '#181's:'
          end
          object Label112: TLabel
            Left = 20
            Top = 464
            Width = 161
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Interval vzor'#269'enja v ms:'
          end
          object LblSmpl: TLabel
            Left = 115
            Top = 489
            Width = 75
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = '( 100 kHz )'
          end
          object Label113: TLabel
            Left = 14
            Top = 582
            Width = 57
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Label113'
          end
          object Label26: TLabel
            Left = 20
            Top = 526
            Width = 102
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = #352'tevilo vzorcev:'
          end
          object Label23: TLabel
            Left = 231
            Top = 37
            Width = 49
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Label23'
          end
          object Label16: TLabel
            Left = 636
            Top = 679
            Width = 49
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Label16'
          end
          object Label24: TLabel
            Left = 785
            Top = 647
            Width = 49
            Height = 18
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Label24'
          end
          object CmbObm: TComboBox
            Left = 20
            Top = 24
            Width = 163
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = ' BIPOLAR 10V'
            Items.Strings = (
              ' BIPOLAR 10V'
              ' UNIPOLAR 10V'
              ' BIPOLAR 2.5V'
              ' UNIPOLAR 2.5V')
          end
          object RgAnConnType: TRadioGroup
            Left = 20
            Top = 60
            Width = 163
            Height = 69
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Na'#269'in priklopa:'
            ItemIndex = 1
            Items.Strings = (
              'Enopolno'
              'Diferencialno')
            TabOrder = 1
          end
          object RgAnScanStart: TRadioGroup
            Left = 20
            Top = 127
            Width = 163
            Height = 69
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Pro'#382'enje vzor'#269'enja:'
            ItemIndex = 0
            Items.Strings = (
              #268'asovno'
              'Na triger')
            TabOrder = 2
          end
          object RgAnAcqStart: TRadioGroup
            Left = 20
            Top = 204
            Width = 163
            Height = 69
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Pro'#382'enje za'#269'etka:'
            ItemIndex = 0
            Items.Strings = (
              'SW'
              'Na triger')
            TabOrder = 3
          end
          object C00: TCheckBox
            Left = 20
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_00, pin39'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 4
          end
          object C01: TCheckBox
            Left = 39
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_01, pin19'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 5
          end
          object C02: TCheckBox
            Left = 59
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_02, pin38'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
          end
          object C03: TCheckBox
            Left = 78
            Top = 299
            Width = 23
            Height = 23
            Hint = 'AI_03, pin18'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
          end
          object C04: TCheckBox
            Left = 106
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_04, pin37'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
          end
          object C05: TCheckBox
            Left = 126
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_05, pin17'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
          end
          object C06: TCheckBox
            Left = 145
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_06, pin36'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
          end
          object C07: TCheckBox
            Left = 165
            Top = 299
            Width = 22
            Height = 23
            Hint = 'AI_07, pin16'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
          end
          object C08: TCheckBox
            Left = 20
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_08, pin78'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
          end
          object C09: TCheckBox
            Left = 39
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_09, pin58'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 13
          end
          object C10: TCheckBox
            Left = 59
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_10, pin77'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 14
          end
          object C11: TCheckBox
            Left = 78
            Top = 324
            Width = 23
            Height = 23
            Hint = 'AI_11, pin57'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 15
          end
          object C12: TCheckBox
            Left = 106
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_12, pin76'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
          end
          object C13: TCheckBox
            Left = 126
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_13, pin56'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
          end
          object C14: TCheckBox
            Left = 145
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_14, pin75'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
          end
          object C15: TCheckBox
            Left = 165
            Top = 324
            Width = 22
            Height = 23
            Hint = 'AI_15, pin55'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 19
          end
          object C16: TCheckBox
            Left = 20
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_16, pin15'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
          end
          object C17: TCheckBox
            Left = 39
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_17, pin34'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 21
          end
          object C18: TCheckBox
            Left = 59
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_18, pin14'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 22
          end
          object C19: TCheckBox
            Left = 78
            Top = 349
            Width = 23
            Height = 22
            Hint = 'AI_19, pin33'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 23
          end
          object C20: TCheckBox
            Left = 106
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_20, pin13'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 24
          end
          object C21: TCheckBox
            Left = 126
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_21, pin32'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 25
          end
          object C22: TCheckBox
            Left = 145
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_22, pin12'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 26
          end
          object C23: TCheckBox
            Left = 165
            Top = 349
            Width = 22
            Height = 22
            Hint = 'AI_23, pin31'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 27
          end
          object C24: TCheckBox
            Left = 20
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_24, pin54'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 28
          end
          object C25: TCheckBox
            Left = 39
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_25, pin73'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 29
          end
          object C26: TCheckBox
            Left = 59
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_26, pin53'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 30
          end
          object C27: TCheckBox
            Left = 78
            Top = 374
            Width = 23
            Height = 22
            Hint = 'AI_27, pin72'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 31
          end
          object C28: TCheckBox
            Left = 106
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_28, pin52'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 32
          end
          object C29: TCheckBox
            Left = 126
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_29, pin71'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 33
          end
          object C30: TCheckBox
            Left = 145
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_30, pin51'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 34
          end
          object C31: TCheckBox
            Left = 165
            Top = 374
            Width = 22
            Height = 22
            Hint = 'AI_31, pin70'
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ParentShowHint = False
            ShowHint = True
            TabOrder = 35
          end
          object EdConvTime: TEdit
            Left = 20
            Top = 425
            Width = 91
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 36
            Text = '5'
          end
          object EdScanTime: TEdit
            Left = 20
            Top = 485
            Width = 91
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 37
            Text = '0,01'
          end
          object EdScanSamplNr: TEdit
            Left = 20
            Top = 547
            Width = 91
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 38
            Text = '0'
          end
          object BtnNastaviAI: TButton
            Left = 14
            Top = 607
            Width = 98
            Height = 32
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Nastavi AI'
            TabOrder = 39
            OnClick = BtnNastaviAIClick
          end
          object Chart16: TChart
            Left = 224
            Top = 72
            Width = 784
            Height = 261
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BackWall.Brush.Gradient.Direction = gdBottomTop
            BackWall.Brush.Gradient.EndColor = clWhite
            BackWall.Brush.Gradient.StartColor = 15395562
            BackWall.Brush.Gradient.Visible = True
            BackWall.Color = 16448250
            BackWall.Transparent = False
            Foot.Font.Color = clBlue
            Foot.Font.Name = 'Verdana'
            Gradient.Direction = gdBottomTop
            Gradient.EndColor = clWhite
            Gradient.MidColor = 15395562
            Gradient.StartColor = 15395562
            Gradient.Visible = True
            LeftWall.Color = 14745599
            Legend.Font.Name = 'Verdana'
            Legend.RoundSize = 48
            Legend.Shadow.Transparency = 0
            Legend.ShapeStyle = fosRoundRectangle
            Legend.Visible = False
            MarginLeft = 1
            MarginRight = 1
            RightWall.Color = 14745599
            SubFoot.Font.Name = 'Verdana'
            SubTitle.Font.Name = 'Verdana'
            Title.Font.Name = 'Verdana'
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.Axis.Color = 4210752
            BottomAxis.ExactDateTime = False
            BottomAxis.Grid.Color = 11119017
            BottomAxis.LabelsFormat.Font.Name = 'Verdana'
            BottomAxis.LabelsFormat.TextAlignment = taCenter
            BottomAxis.TicksInner.Color = 11119017
            BottomAxis.Title.Font.Name = 'Verdana'
            DepthAxis.Axis.Color = 4210752
            DepthAxis.Grid.Color = 11119017
            DepthAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthAxis.LabelsFormat.TextAlignment = taCenter
            DepthAxis.TicksInner.Color = 11119017
            DepthAxis.Title.Font.Name = 'Verdana'
            DepthTopAxis.Axis.Color = 4210752
            DepthTopAxis.Grid.Color = 11119017
            DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthTopAxis.LabelsFormat.TextAlignment = taCenter
            DepthTopAxis.TicksInner.Color = 11119017
            DepthTopAxis.Title.Font.Name = 'Verdana'
            LeftAxis.Axis.Color = 4210752
            LeftAxis.AxisValuesFormat = '#,##0.####'
            LeftAxis.Grid.Color = 11119017
            LeftAxis.LabelsFormat.Font.Name = 'Verdana'
            LeftAxis.LabelsFormat.TextAlignment = taCenter
            LeftAxis.LabelsSize = 40
            LeftAxis.TicksInner.Color = 11119017
            LeftAxis.Title.Font.Name = 'Verdana'
            RightAxis.Axis.Color = 4210752
            RightAxis.Grid.Color = 11119017
            RightAxis.LabelsFormat.Font.Name = 'Verdana'
            RightAxis.LabelsFormat.TextAlignment = taCenter
            RightAxis.TicksInner.Color = 11119017
            RightAxis.Title.Font.Name = 'Verdana'
            TopAxis.Axis.Color = 4210752
            TopAxis.Grid.Color = 11119017
            TopAxis.LabelsFormat.Font.Name = 'Verdana'
            TopAxis.LabelsFormat.TextAlignment = taCenter
            TopAxis.TicksInner.Color = 11119017
            TopAxis.Title.Font.Name = 'Verdana'
            View3D = False
            Zoom.AnimatedSteps = 20
            Zoom.Brush.Color = clSilver
            Zoom.Brush.Style = bsSolid
            Zoom.MinimumPixels = 4
            Zoom.Pen.Color = clBlack
            Zoom.Pen.Mode = pmNotXor
            Zoom.Pen.Style = psDot
            Zoom.Pen.Width = 1
            Color = 15724527
            TabOrder = 40
            DefaultCanvas = 'TTeeCanvas3D'
            ColorPaletteIndex = 13
            object Series1: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 10708548
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series2: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 3513587
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series3: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 1330417
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series4: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 11048782
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object BtnRisiSignale: TButton
            Left = 543
            Top = 4
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Risi'
            TabOrder = 41
          end
          object BtnStartAI: TButton
            Left = 224
            Top = 4
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Start'
            TabOrder = 42
          end
          object BtnStopAI: TButton
            Left = 330
            Top = 4
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Stop'
            TabOrder = 43
          end
          object Button24: TButton
            Left = 649
            Top = 4
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Risi n povp'
            TabOrder = 44
          end
          object EdPovp: TEdit
            Left = 755
            Top = 7
            Width = 58
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 45
            Text = '100'
          end
          object CbVsakaDeseta: TCheckBox
            Left = 549
            Top = 35
            Width = 127
            Height = 23
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'vsakadeseta'
            Checked = True
            State = cbChecked
            TabOrder = 46
          end
          object Button27: TButton
            Left = 214
            Top = 672
            Width = 99
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Meri'
            TabOrder = 47
            OnClick = Button27Click
          end
          object Button1: TButton
            Left = 833
            Top = 4
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Risi'
            TabOrder = 48
          end
          object Button4: TButton
            Left = 530
            Top = 672
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Meri Ke'
            TabOrder = 49
            OnClick = Button4Click
          end
          object Button6: TButton
            Left = 400
            Top = 612
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Hitrost/'#269'as'
            TabOrder = 50
            OnClick = Button6Click
          end
          object Chart1: TChart
            Left = 224
            Top = 343
            Width = 784
            Height = 261
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BackWall.Brush.Gradient.Direction = gdBottomTop
            BackWall.Brush.Gradient.EndColor = clWhite
            BackWall.Brush.Gradient.StartColor = 15395562
            BackWall.Brush.Gradient.Visible = True
            BackWall.Color = 16448250
            BackWall.Transparent = False
            Foot.Font.Color = clBlue
            Foot.Font.Name = 'Verdana'
            Gradient.Direction = gdBottomTop
            Gradient.EndColor = clWhite
            Gradient.MidColor = 15395562
            Gradient.StartColor = 15395562
            Gradient.Visible = True
            LeftWall.Color = 14745599
            Legend.Font.Name = 'Verdana'
            Legend.RoundSize = 48
            Legend.Shadow.Transparency = 0
            Legend.ShapeStyle = fosRoundRectangle
            Legend.Visible = False
            MarginLeft = 1
            MarginRight = 1
            RightWall.Color = 14745599
            SubFoot.Font.Name = 'Verdana'
            SubTitle.Font.Name = 'Verdana'
            Title.Font.Name = 'Verdana'
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.Axis.Color = 4210752
            BottomAxis.ExactDateTime = False
            BottomAxis.Grid.Color = 11119017
            BottomAxis.LabelsFormat.Font.Name = 'Verdana'
            BottomAxis.LabelsFormat.TextAlignment = taCenter
            BottomAxis.TicksInner.Color = 11119017
            BottomAxis.Title.Font.Name = 'Verdana'
            DepthAxis.Axis.Color = 4210752
            DepthAxis.Grid.Color = 11119017
            DepthAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthAxis.LabelsFormat.TextAlignment = taCenter
            DepthAxis.TicksInner.Color = 11119017
            DepthAxis.Title.Font.Name = 'Verdana'
            DepthTopAxis.Axis.Color = 4210752
            DepthTopAxis.Grid.Color = 11119017
            DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthTopAxis.LabelsFormat.TextAlignment = taCenter
            DepthTopAxis.TicksInner.Color = 11119017
            DepthTopAxis.Title.Font.Name = 'Verdana'
            LeftAxis.Axis.Color = 4210752
            LeftAxis.AxisValuesFormat = '#,##0.####'
            LeftAxis.Grid.Color = 11119017
            LeftAxis.LabelsFormat.Font.Name = 'Verdana'
            LeftAxis.LabelsFormat.TextAlignment = taCenter
            LeftAxis.LabelsSize = 40
            LeftAxis.TicksInner.Color = 11119017
            LeftAxis.Title.Font.Name = 'Verdana'
            RightAxis.Axis.Color = 4210752
            RightAxis.Grid.Color = 11119017
            RightAxis.LabelsFormat.Font.Name = 'Verdana'
            RightAxis.LabelsFormat.TextAlignment = taCenter
            RightAxis.TicksInner.Color = 11119017
            RightAxis.Title.Font.Name = 'Verdana'
            TopAxis.Axis.Color = 4210752
            TopAxis.Grid.Color = 11119017
            TopAxis.LabelsFormat.Font.Name = 'Verdana'
            TopAxis.LabelsFormat.TextAlignment = taCenter
            TopAxis.TicksInner.Color = 11119017
            TopAxis.Title.Font.Name = 'Verdana'
            View3D = False
            Zoom.AnimatedSteps = 20
            Zoom.Brush.Color = clSilver
            Zoom.Brush.Style = bsSolid
            Zoom.MinimumPixels = 4
            Zoom.Pen.Color = clBlack
            Zoom.Pen.Mode = pmNotXor
            Zoom.Pen.Style = psDot
            Zoom.Pen.Width = 1
            Color = 15724527
            TabOrder = 51
            DefaultCanvas = 'TTeeCanvas3D'
            ColorPaletteIndex = 13
            object Series5: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 10708548
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series6: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 3513587
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series7: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 1330417
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series8: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 11048782
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series9: TFastLineSeries
              Marks.Visible = False
              LinePen.Color = 7028779
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object Edit1: TEdit
            Left = 222
            Top = 615
            Width = 64
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            TabOrder = 52
            Text = '2'
          end
          object Button7: TButton
            Left = 612
            Top = 612
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Tok/hitrost'
            TabOrder = 53
            OnClick = Button7Click
          end
          object Button8: TButton
            Left = 294
            Top = 612
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Pot/'#269'as'
            TabOrder = 54
            OnClick = Button8Click
          end
          object Button10: TButton
            Left = 506
            Top = 612
            Width = 98
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Tok/'#269'as'
            TabOrder = 55
            OnClick = Button10Click
          end
          object BtnVnesiParametreMotorja: TButton
            Left = 783
            Top = 612
            Width = 138
            Height = 33
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Prvi pribli'#382'ek'
            TabOrder = 56
            OnClick = BtnVnesiParametreMotorjaClick
          end
        end
      end
    end
    object StBar5: TStatusBar
      Left = 0
      Top = 926
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end>
      ParentDoubleBuffered = False
      SizeGrip = False
      OnDblClick = StBar5DblClick
      OnDrawPanel = StBar5DrawPanel
    end
    object StBar0: TStatusBar
      Left = 0
      Top = 831
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
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
    object StBar1: TStatusBar
      Left = 0
      Top = 850
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end>
      ParentDoubleBuffered = False
      SizeGrip = False
      OnDblClick = StBar1DblClick
      OnDrawPanel = StBar1DrawPanel
    end
    object StBar2: TStatusBar
      Left = 0
      Top = 869
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end>
      ParentDoubleBuffered = False
      SizeGrip = False
      OnDblClick = StBar2DblClick
      OnDrawPanel = StBar2DrawPanel
    end
    object StBar3: TStatusBar
      Left = 0
      Top = 888
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end>
      ParentDoubleBuffered = False
      SizeGrip = False
      OnDblClick = StBar3DblClick
      OnDrawPanel = StBar3DrawPanel
    end
    object StBar4: TStatusBar
      Left = 0
      Top = 907
      Width = 1061
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DoubleBuffered = True
      Panels = <
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 50
        end
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
          Width = 24
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 63
        end
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
          Width = 60
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 30
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 32
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 35
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 65
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 70
        end>
      ParentDoubleBuffered = False
      SizeGrip = False
      OnDblClick = StBar4DblClick
      OnDrawPanel = StBar4DrawPanel
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 1061
      Height = 35
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvLowered
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 7
      DesignSize = (
        1061
        35)
      object Label37: TLabel
        Left = 787
        Top = 8
        Width = 61
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Kontroler:'
      end
      object Label22: TLabel
        Left = 541
        Top = 8
        Width = 122
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Napajalna napetost:'
      end
      object Label45: TLabel
        Left = 730
        Top = 8
        Width = 8
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'V'
      end
      object CmbBoxKontrolerji: TComboBox
        Left = 867
        Top = 3
        Width = 187
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Anchors = [akTop, akRight]
        DoubleBuffered = False
        DropDownCount = 50
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentDoubleBuffered = False
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnChange = CmbBoxKontrolerjiChange
      end
      object EdVbus: TEdit
        Left = 677
        Top = 3
        Width = 46
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        TabOrder = 1
        Text = '24'
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 680
    Top = 65528
  end
  object OpenDialog1: TOpenDialog
    Left = 640
    Top = 4
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 580
  end
end
