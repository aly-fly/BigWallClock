object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 810
  ClientWidth = 811
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 811
    Height = 810
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object TabCnOs: TTabControl
      Left = 0
      Top = 27
      Width = 811
      Height = 669
      Align = alClient
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
        Top = 24
        Width = 803
        Height = 641
        ActivePage = TbShUkazi
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        MultiLine = True
        ParentFont = False
        TabOrder = 0
        object TbShUkazi: TTabSheet
          Caption = 'Ukazi'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ImageIndex = 2
          ParentFont = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object PnlPwrKomande: TPanel
            Left = 0
            Top = 187
            Width = 260
            Height = 369
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 0
            object Label4: TLabel
              Left = 8
              Top = 8
              Width = 86
              Height = 13
              Caption = 'Run with speed'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 8
              Top = 121
              Width = 94
              Height = 13
              Caption = 'Move for N steps'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label7: TLabel
              Left = 8
              Top = 143
              Width = 77
              Height = 13
              Caption = 'GoTo position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label8: TLabel
              Left = 8
              Top = 31
              Width = 108
              Height = 13
              Caption = 'GoTo Sw, set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label9: TLabel
              Left = 8
              Top = 75
              Width = 124
              Height = 13
              Caption = 'Release Sw, set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label10: TLabel
              Left = 8
              Top = 213
              Width = 29
              Height = 13
              Caption = 'STOP'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label12: TLabel
              Left = 8
              Top = 189
              Width = 30
              Height = 13
              Caption = 'Go to'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label18: TLabel
              Left = 8
              Top = 237
              Width = 69
              Height = 13
              Caption = 'Driver in HiZ'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label14: TLabel
              Left = 8
              Top = 53
              Width = 127
              Height = 13
              Caption = 'GoTo Sw, preset MARK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label32: TLabel
              Left = 8
              Top = 98
              Width = 143
              Height = 13
              Caption = 'Release Sw, preset MARK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label33: TLabel
              Left = 8
              Top = 166
              Width = 77
              Height = 13
              Caption = 'GoTo position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label38: TLabel
              Left = 8
              Top = 260
              Width = 81
              Height = 13
              Caption = 'Reset position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label44: TLabel
              Left = 8
              Top = 283
              Width = 96
              Height = 13
              Caption = 'Device soft reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label1: TLabel
              Left = 8
              Top = 306
              Width = 100
              Height = 13
              Caption = 'Device hard reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BtnPwr_RunFw: TButton
              Left = 204
              Top = 5
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = BtnPwr_RunFwClick
            end
            object BtnPwr_MoveFw: TButton
              Left = 204
              Top = 118
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              OnClick = BtnPwr_MoveFwClick
            end
            object BtnPwr_GoTo: TButton
              Left = 158
              Top = 163
              Width = 91
              Height = 21
              Caption = 'SHORT'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              OnClick = BtnPwr_GoToClick
            end
            object BtnPwr_GoToDirFwd: TButton
              Left = 204
              Top = 140
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              OnClick = BtnPwr_GoToDirFwdClick
            end
            object BtnPwr_GoUntil_dFwd: TButton
              Left = 204
              Top = 28
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 10
              OnClick = BtnPwr_GoUntil_dFwdClick
            end
            object BtnPwr_GoHome: TButton
              Left = 204
              Top = 186
              Width = 45
              Height = 22
              Caption = 'Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              OnClick = BtnPwr_GoHomeClick
            end
            object BtnPwr_GoMark: TButton
              Left = 158
              Top = 186
              Width = 45
              Height = 22
              Caption = 'Mark'
              TabOrder = 7
              OnClick = BtnPwr_GoMarkClick
            end
            object BtnPwr_ResetPos: TButton
              Left = 158
              Top = 257
              Width = 91
              Height = 22
              Caption = 'Set Home'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 17
              OnClick = BtnPwr_ResetPosClick
            end
            object BtnPwr_ResetDevice: TButton
              Left = 158
              Top = 280
              Width = 91
              Height = 22
              Caption = 'Device Reset'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 18
              OnClick = BtnPwr_ResetDeviceClick
            end
            object BtnPwr_SoftStop: TButton
              Left = 158
              Top = 210
              Width = 45
              Height = 22
              Caption = 'Soft'
              TabOrder = 13
              OnClick = BtnPwr_SoftStopClick
            end
            object BtnPwr_HardStop: TButton
              Left = 204
              Top = 210
              Width = 45
              Height = 22
              Caption = 'Hard'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              OnClick = BtnPwr_HardStopClick
            end
            object BtnPwr_SoftHiZ: TButton
              Left = 158
              Top = 234
              Width = 45
              Height = 22
              Caption = 'Soft'
              TabOrder = 15
              OnClick = BtnPwr_SoftHiZClick
            end
            object BtnPwr_HardHiZ: TButton
              Left = 204
              Top = 234
              Width = 45
              Height = 22
              Caption = 'Hard'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = BtnPwr_HardHiZClick
            end
            object BtnPwr_RunBck: TButton
              Left = 158
              Top = 5
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = BtnPwr_RunBckClick
            end
            object BtnPwr_MoveBck: TButton
              Left = 158
              Top = 118
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = BtnPwr_MoveBckClick
            end
            object BtnPwr_GoToDirBck: TButton
              Left = 158
              Top = 140
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = BtnPwr_GoToDirBckClick
            end
            object BtnPwr_GoUntil_dBck: TButton
              Left = 158
              Top = 28
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
              OnClick = BtnPwr_GoUntil_dBckClick
            end
            object BtnPwr_ReleseSW_dFwd: TButton
              Left = 204
              Top = 72
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              OnClick = BtnPwr_ReleseSW_dFwdClick
            end
            object BtnPwr_ReleseSW_dBck: TButton
              Left = 158
              Top = 72
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
              OnClick = BtnPwr_ReleseSW_dBckClick
            end
            object Button2: TButton
              Left = 8
              Top = 329
              Width = 241
              Height = 34
              Caption = 'Hi Z'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -19
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 19
              OnClick = Button2Click
            end
            object Button13: TButton
              Left = 158
              Top = 50
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 20
              OnClick = Button13Click
            end
            object Button14: TButton
              Left = 204
              Top = 50
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 21
              OnClick = Button14Click
            end
            object Button15: TButton
              Left = 158
              Top = 95
              Width = 45
              Height = 21
              Caption = '<--'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 22
              OnClick = Button15Click
            end
            object Button16: TButton
              Left = 204
              Top = 95
              Width = 45
              Height = 21
              Caption = '-->'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 23
              OnClick = Button16Click
            end
            object BtnHwReset: TButton
              Left = 158
              Top = 303
              Width = 91
              Height = 22
              Caption = 'Device reset'
              TabOrder = 24
              OnClick = BtnHwResetClick
            end
          end
          object PnlPwrGibParam: TPanel
            Left = 0
            Top = 0
            Width = 260
            Height = 73
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            object Label17: TLabel
              Left = 8
              Top = 8
              Width = 41
              Height = 13
              Caption = 'Speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label34: TLabel
              Left = 8
              Top = 30
              Width = 51
              Height = 13
              Caption = 'Position :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label35: TLabel
              Left = 8
              Top = 52
              Width = 47
              Height = 13
              Caption = 'N steps :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label36: TLabel
              Left = 147
              Top = 8
              Width = 24
              Height = 13
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object EdStpNstep: TEdit
              Left = 77
              Top = 49
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '1000'
            end
            object EdStpSpeed: TEdit
              Left = 77
              Top = 5
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '1000'
            end
            object EdStpAbsPos: TEdit
              Left = 77
              Top = 27
              Width = 66
              Height = 21
              TabOrder = 2
              Text = '1000'
            end
            object CbCiguMigu: TCheckBox
              Left = 183
              Top = 55
              Width = 75
              Height = 17
              Caption = 'Move cyclic'
              TabOrder = 3
              OnClick = CbCiguMiguClick
            end
          end
          object PnlPwrGibParam2: TPanel
            Left = 0
            Top = 72
            Width = 260
            Height = 117
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 2
            object Label39: TLabel
              Left = 8
              Top = 51
              Width = 51
              Height = 13
              Caption = 'Acceler. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label40: TLabel
              Left = 8
              Top = 73
              Width = 52
              Height = 13
              Caption = 'Deceler. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label41: TLabel
              Left = 147
              Top = 51
              Width = 29
              Height = 13
              Caption = 'stp/s'#178
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label42: TLabel
              Left = 147
              Top = 72
              Width = 29
              Height = 13
              Caption = 'stp/s'#178
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label43: TLabel
              Left = 8
              Top = 7
              Width = 67
              Height = 13
              Caption = 'Max speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label46: TLabel
              Left = 147
              Top = 7
              Width = 24
              Height = 13
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label47: TLabel
              Left = 8
              Top = 29
              Width = 63
              Height = 13
              Caption = 'Min speed :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label48: TLabel
              Left = 147
              Top = 29
              Width = 24
              Height = 13
              Caption = 'stp/s'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 8
              Top = 95
              Width = 61
              Height = 13
              Caption = 'Mark pos. :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object EdStpAcceleration: TEdit
              Left = 77
              Top = 48
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '10'
            end
            object EdStpDeceleration: TEdit
              Left = 77
              Top = 70
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '10'
            end
            object EdStpMaxSpeed: TEdit
              Left = 77
              Top = 4
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = '10'
            end
            object EdStpMinSpeed: TEdit
              Left = 77
              Top = 26
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = '10'
            end
            object BtnSetMovements: TButton
              Left = 204
              Top = 92
              Width = 45
              Height = 21
              Caption = 'SET'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = BtnSetMovementsClick
            end
            object EdStpMarkPos: TEdit
              Left = 77
              Top = 92
              Width = 66
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Text = '10000'
            end
            object Button23: TButton
              Left = 204
              Top = 69
              Width = 45
              Height = 21
              Caption = 'READ'
              TabOrder = 6
              OnClick = Button23Click
            end
          end
          object GroupBox_PwrClkSet: TGroupBox
            Left = 264
            Top = 0
            Width = 521
            Height = 362
            Caption = '>>>>>   K O N F I G U R A C I J E   <<<<<'
            Color = clCream
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentBackground = False
            ParentColor = False
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            object Label11: TLabel
              Left = 8
              Top = 130
              Width = 81
              Height = 13
              Caption = 'Clock frequency:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label13: TLabel
              Left = 8
              Top = 153
              Width = 57
              Height = 13
              Caption = 'OscOut pin:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblConf_PwmTswN: TLabel
              Left = 266
              Top = 42
              Width = 90
              Height = 13
              Caption = 'LblConf_PwmTswN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblConf_PwmTswV: TLabel
              Left = 390
              Top = 42
              Width = 89
              Height = 13
              Caption = 'LblConf_PwmTswV'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 262
              Top = 154
              Width = 55
              Height = 13
              Caption = 'Step mode:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label15: TLabel
              Left = 262
              Top = 177
              Width = 56
              Height = 13
              Caption = 'Sync mode:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label27: TLabel
              Left = 262
              Top = 213
              Width = 68
              Height = 13
              Caption = 'Gate current :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 262
              Top = 236
              Width = 112
              Height = 13
              Caption = 'Constant current time :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label29: TLabel
              Left = 262
              Top = 259
              Width = 99
              Height = 13
              Caption = 'Turn off boost time :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 262
              Top = 282
              Width = 52
              Height = 13
              Caption = 'Dead time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 262
              Top = 305
              Width = 66
              Height = 13
              Caption = 'Blanking time:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblKval: TLabel
              Left = 261
              Top = 327
              Width = 24
              Height = 13
              Caption = 'Tok: '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object RgConf_ClkSrc: TRadioGroup
              Left = 3
              Top = 51
              Width = 242
              Height = 37
              Caption = 'Clock source:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 3
              Top = 87
              Width = 242
              Height = 37
              Caption = 'External source type:'
              Columns = 2
              DoubleBuffered = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 116
              Top = 126
              Width = 129
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 116
              Top = 149
              Width = 129
              Height = 21
              Style = csDropDownList
              DoubleBuffered = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 8
              Top = 175
              Width = 238
              Height = 17
              Caption = 'Enable controller reset at clock error detection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              OnClick = CmbBConf_WD_ENClick
            end
            object RgConf_ExtSW: TRadioGroup
              Left = 3
              Top = 197
              Width = 242
              Height = 37
              Caption = 'External switch mode:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 8
              Top = 240
              Width = 201
              Height = 17
              Caption = 'Turn off bridges at overcurrent'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              OnClick = CmbBConf_BridgOffClick
            end
            object RgConf_VccVolt: TRadioGroup
              Left = 4
              Top = 262
              Width = 242
              Height = 37
              Caption = 'Vcc voltage regulator value:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 3
              Top = 299
              Width = 242
              Height = 37
              Caption = 'Undervoltage treshold settings:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 262
              Top = 19
              Width = 222
              Height = 17
              Caption = 'CmbBConf_Bit5'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
              OnClick = CmbBConf_Bit5Click
            end
            object TbConfigPwmTsw: TTrackBar
              Left = 257
              Top = 55
              Width = 242
              Height = 22
              Max = 100
              Position = 80
              ShowSelRange = False
              TabOrder = 10
              ThumbLength = 18
              TickStyle = tsNone
              OnChange = TbConfigPwmTswChange
            end
            object CmbBConf_PredEn: TCheckBox
              Left = 4
              Top = 337
              Width = 165
              Height = 17
              Caption = 'Predictive current control'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
              OnClick = CmbBConf_PredEnClick
            end
            object CbAl_7: TCheckBox
              Left = 262
              Top = 78
              Width = 120
              Height = 17
              Caption = 'Command error'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              OnClick = CbAl_7Click
            end
            object CbAl_6: TCheckBox
              Left = 262
              Top = 93
              Width = 120
              Height = 17
              Caption = 'Switch turn-on event'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 13
              OnClick = CbAl_6Click
            end
            object CbAl_5: TCheckBox
              Left = 262
              Top = 108
              Width = 120
              Height = 17
              Caption = 'Stall detection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              OnClick = CbAl_5Click
            end
            object CbAl_4: TCheckBox
              Left = 262
              Top = 123
              Width = 120
              Height = 17
              Caption = 'ADC UVLO'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 15
              OnClick = CbAl_4Click
            end
            object CbAl_3: TCheckBox
              Left = 385
              Top = 78
              Width = 115
              Height = 17
              Caption = 'UVLO'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              OnClick = CbAl_3Click
            end
            object CbAl_2: TCheckBox
              Left = 385
              Top = 93
              Width = 115
              Height = 17
              Caption = 'Thermal warning'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 17
              OnClick = CbAl_2Click
            end
            object CbAl_1: TCheckBox
              Left = 385
              Top = 108
              Width = 115
              Height = 17
              Caption = 'Thermal shutdown'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 18
              OnClick = CbAl_1Click
            end
            object CbAl_0: TCheckBox
              Left = 385
              Top = 123
              Width = 115
              Height = 17
              Caption = 'Overcurrent'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 19
              OnClick = CbAl_0Click
            end
            object RgPwrConfMode: TRadioGroup
              Left = 3
              Top = 16
              Width = 242
              Height = 37
              Caption = 'Operation mode:'
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 380
              Top = 151
              Width = 119
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 381
              Top = 178
              Width = 119
              Height = 21
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 94
              Top = 337
              Width = 138
              Height = 17
              Caption = 'Low speed optimisation'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 23
              OnClick = CmbBConf_LowSpeedOptClick
            end
            object CmbBConf_IGATE: TComboBox
              Left = 380
              Top = 210
              Width = 119
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 380
              Top = 233
              Width = 119
              Height = 21
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 380
              Top = 256
              Width = 119
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 380
              Top = 279
              Width = 119
              Height = 21
              Style = csDropDownList
              DropDownCount = 9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 380
              Top = 302
              Width = 119
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 259
              Top = 340
              Width = 254
              Height = 20
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
            Left = 266
            Top = 366
            Width = 347
            Height = 192
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 4
            object Label19: TLabel
              Left = 202
              Top = 44
              Width = 45
              Height = 13
              Caption = 'Ke [V/Hz]'
            end
            object Label20: TLabel
              Left = 202
              Top = 66
              Width = 40
              Height = 13
              Caption = 'R [Ohm]'
            end
            object Label21: TLabel
              Left = 202
              Top = 89
              Width = 31
              Height = 13
              Caption = 'L [mH]'
            end
            object Label2: TLabel
              Left = 10
              Top = 8
              Width = 32
              Height = 13
              Caption = 'Motor:'
            end
            object Label49: TLabel
              Left = 9
              Top = 36
              Width = 137
              Height = 13
              Caption = 'Uporabi privzete nastavitve:'
            end
            object EdKe: TEdit
              Left = 260
              Top = 40
              Width = 55
              Height = 21
              Ctl3D = True
              ParentCtl3D = False
              TabOrder = 0
              Text = '0,023'
            end
            object EdRm: TEdit
              Left = 260
              Top = 63
              Width = 55
              Height = 21
              TabOrder = 1
              Text = '5,9'
            end
            object EdLm: TEdit
              Left = 260
              Top = 86
              Width = 55
              Height = 21
              TabOrder = 2
              Text = '4,2'
            end
            object CmbBoxMotorji: TComboBox
              Left = 48
              Top = 5
              Width = 183
              Height = 21
              DoubleBuffered = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
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
              Left = 6
              Top = 52
              Width = 80
              Height = 25
              Caption = 'Voltage'
              TabOrder = 4
              OnClick = BtnVoltageDefaultClick
            end
            object BtnCurrentDefault: TButton
              Left = 92
              Top = 52
              Width = 80
              Height = 25
              Caption = 'Current'
              TabOrder = 5
              OnClick = BtnCurrentDefaultClick
            end
            object BtnDodajMotor: TButton
              Left = 237
              Top = 4
              Width = 56
              Height = 22
              Caption = 'Dodaj'
              TabOrder = 6
              OnClick = BtnDodajMotorClick
            end
          end
          object PnlSaveLoad: TPanel
            Left = 619
            Top = 366
            Width = 166
            Height = 192
            BevelInner = bvLowered
            Color = clCream
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentFont = False
            TabOrder = 5
            object BtnSaveConfig: TButton
              Left = 11
              Top = 84
              Width = 60
              Height = 25
              Caption = 'Shrani'
              TabOrder = 0
              OnClick = BtnSaveConfigClick
            end
            object BtnOpenConfig: TButton
              Left = 8
              Top = 10
              Width = 85
              Height = 25
              Caption = 'Nalo'#382'i'
              TabOrder = 1
              OnClick = BtnOpenConfigClick
            end
            object BtnPwrBeriVse: TButton
              Left = 8
              Top = 37
              Width = 85
              Height = 25
              Caption = 'Beri vse'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = BtnPwrBeriVseClick
            end
            object Button5: TButton
              Left = 11
              Top = 115
              Width = 62
              Height = 25
              Caption = 'Edit'
              TabOrder = 3
              OnClick = Button5Click
            end
            object Button3: TButton
              Left = 12
              Top = 154
              Width = 75
              Height = 25
              Caption = 'Button3'
              TabOrder = 4
              OnClick = Button3Click
            end
          end
        end
        object TbShRegistri: TTabSheet
          Caption = 'Registri'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 1228
          ExplicitHeight = 0
          object StringGrid1: TStringGrid
            Left = 0
            Top = 0
            Width = 813
            Height = 597
            ColCount = 9
            DefaultRowHeight = 20
            DoubleBuffered = True
            FixedCols = 0
            RowCount = 28
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
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
          Caption = 'Merjenje'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 1228
          ExplicitHeight = 0
          object Label109: TLabel
            Left = 15
            Top = 4
            Width = 91
            Height = 13
            Caption = 'Obmo'#269'je merjenja:'
          end
          object Label110: TLabel
            Left = 15
            Top = 215
            Width = 32
            Height = 13
            Caption = 'Kanali:'
          end
          object Label111: TLabel
            Left = 15
            Top = 309
            Width = 98
            Height = 13
            Caption = #268'as med kanali v '#181's:'
          end
          object Label112: TLabel
            Left = 15
            Top = 355
            Width = 117
            Height = 13
            Caption = 'Interval vzor'#269'enja v ms:'
          end
          object LblSmpl: TLabel
            Left = 88
            Top = 374
            Width = 52
            Height = 13
            Caption = '( 100 kHz )'
          end
          object Label113: TLabel
            Left = 11
            Top = 445
            Width = 43
            Height = 13
            Caption = 'Label113'
          end
          object Label26: TLabel
            Left = 15
            Top = 402
            Width = 77
            Height = 13
            Caption = #352'tevilo vzorcev:'
          end
          object Label23: TLabel
            Left = 177
            Top = 28
            Width = 37
            Height = 13
            Caption = 'Label23'
          end
          object Label16: TLabel
            Left = 486
            Top = 519
            Width = 37
            Height = 13
            Caption = 'Label16'
          end
          object Label24: TLabel
            Left = 600
            Top = 495
            Width = 37
            Height = 13
            Caption = 'Label24'
          end
          object CmbObm: TComboBox
            Left = 15
            Top = 18
            Width = 125
            Height = 21
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
            Left = 15
            Top = 46
            Width = 125
            Height = 53
            Caption = 'Na'#269'in priklopa:'
            ItemIndex = 1
            Items.Strings = (
              'Enopolno'
              'Diferencialno')
            TabOrder = 1
          end
          object RgAnScanStart: TRadioGroup
            Left = 15
            Top = 97
            Width = 125
            Height = 53
            Caption = 'Pro'#382'enje vzor'#269'enja:'
            ItemIndex = 0
            Items.Strings = (
              #268'asovno'
              'Na triger')
            TabOrder = 2
          end
          object RgAnAcqStart: TRadioGroup
            Left = 15
            Top = 156
            Width = 125
            Height = 53
            Caption = 'Pro'#382'enje za'#269'etka:'
            ItemIndex = 0
            Items.Strings = (
              'SW'
              'Na triger')
            TabOrder = 3
          end
          object C00: TCheckBox
            Left = 15
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_00, pin39'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 4
          end
          object C01: TCheckBox
            Left = 30
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_01, pin19'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 5
          end
          object C02: TCheckBox
            Left = 45
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_02, pin38'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
          end
          object C03: TCheckBox
            Left = 60
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_03, pin18'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
          end
          object C04: TCheckBox
            Left = 81
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_04, pin37'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
          end
          object C05: TCheckBox
            Left = 96
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_05, pin17'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
          end
          object C06: TCheckBox
            Left = 111
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_06, pin36'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
          end
          object C07: TCheckBox
            Left = 126
            Top = 229
            Width = 17
            Height = 17
            Hint = 'AI_07, pin16'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
          end
          object C08: TCheckBox
            Left = 15
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_08, pin78'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
          end
          object C09: TCheckBox
            Left = 30
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_09, pin58'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 13
          end
          object C10: TCheckBox
            Left = 45
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_10, pin77'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 14
          end
          object C11: TCheckBox
            Left = 60
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_11, pin57'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 15
          end
          object C12: TCheckBox
            Left = 81
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_12, pin76'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
          end
          object C13: TCheckBox
            Left = 96
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_13, pin56'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
          end
          object C14: TCheckBox
            Left = 111
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_14, pin75'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
          end
          object C15: TCheckBox
            Left = 126
            Top = 248
            Width = 17
            Height = 17
            Hint = 'AI_15, pin55'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 19
          end
          object C16: TCheckBox
            Left = 15
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_16, pin15'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
          end
          object C17: TCheckBox
            Left = 30
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_17, pin34'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 21
          end
          object C18: TCheckBox
            Left = 45
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_18, pin14'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 22
          end
          object C19: TCheckBox
            Left = 60
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_19, pin33'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 23
          end
          object C20: TCheckBox
            Left = 81
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_20, pin13'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 24
          end
          object C21: TCheckBox
            Left = 96
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_21, pin32'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 25
          end
          object C22: TCheckBox
            Left = 111
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_22, pin12'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 26
          end
          object C23: TCheckBox
            Left = 126
            Top = 267
            Width = 17
            Height = 17
            Hint = 'AI_23, pin31'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 27
          end
          object C24: TCheckBox
            Left = 15
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_24, pin54'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 28
          end
          object C25: TCheckBox
            Left = 30
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_25, pin73'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 29
          end
          object C26: TCheckBox
            Left = 45
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_26, pin53'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 30
          end
          object C27: TCheckBox
            Left = 60
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_27, pin72'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 31
          end
          object C28: TCheckBox
            Left = 81
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_28, pin52'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 32
          end
          object C29: TCheckBox
            Left = 96
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_29, pin71'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 33
          end
          object C30: TCheckBox
            Left = 111
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_30, pin51'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 34
          end
          object C31: TCheckBox
            Left = 126
            Top = 286
            Width = 17
            Height = 17
            Hint = 'AI_31, pin70'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 35
          end
          object EdConvTime: TEdit
            Left = 15
            Top = 325
            Width = 70
            Height = 21
            TabOrder = 36
            Text = '5'
          end
          object EdScanTime: TEdit
            Left = 15
            Top = 371
            Width = 70
            Height = 21
            TabOrder = 37
            Text = '0,01'
          end
          object EdScanSamplNr: TEdit
            Left = 15
            Top = 418
            Width = 70
            Height = 21
            TabOrder = 38
            Text = '0'
          end
          object BtnNastaviAI: TButton
            Left = 11
            Top = 464
            Width = 75
            Height = 25
            Caption = 'Nastavi AI'
            TabOrder = 39
            OnClick = BtnNastaviAIClick
          end
          object Chart16: TChart
            Left = 171
            Top = 55
            Width = 600
            Height = 200
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
            BottomAxis.TicksInner.Color = 11119017
            BottomAxis.Title.Font.Name = 'Verdana'
            DepthAxis.Axis.Color = 4210752
            DepthAxis.Grid.Color = 11119017
            DepthAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthAxis.TicksInner.Color = 11119017
            DepthAxis.Title.Font.Name = 'Verdana'
            DepthTopAxis.Axis.Color = 4210752
            DepthTopAxis.Grid.Color = 11119017
            DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthTopAxis.TicksInner.Color = 11119017
            DepthTopAxis.Title.Font.Name = 'Verdana'
            Hover.Visible = False
            LeftAxis.Axis.Color = 4210752
            LeftAxis.AxisValuesFormat = '#,##0.####'
            LeftAxis.Grid.Color = 11119017
            LeftAxis.LabelsFormat.Font.Name = 'Verdana'
            LeftAxis.LabelsSize = 40
            LeftAxis.TicksInner.Color = 11119017
            LeftAxis.Title.Font.Name = 'Verdana'
            RightAxis.Axis.Color = 4210752
            RightAxis.Grid.Color = 11119017
            RightAxis.LabelsFormat.Font.Name = 'Verdana'
            RightAxis.TicksInner.Color = 11119017
            RightAxis.Title.Font.Name = 'Verdana'
            TopAxis.Axis.Color = 4210752
            TopAxis.Grid.Color = 11119017
            TopAxis.LabelsFormat.Font.Name = 'Verdana'
            TopAxis.TicksInner.Color = 11119017
            TopAxis.Title.Font.Name = 'Verdana'
            View3D = False
            Zoom.AnimatedSteps = 20
            Zoom.Brush.Color = clSilver
            Zoom.Brush.Style = bsSolid
            Zoom.MinimumPixels = 4
            Zoom.Pen.Color = clBlack
            Zoom.Pen.Style = psDot
            Zoom.Pen.Width = 1
            Color = 15724527
            TabOrder = 40
            DefaultCanvas = 'TTeeCanvas3D'
            ColorPaletteIndex = 13
            object Series1: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 10708548
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series2: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 3513587
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series3: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 1330417
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series4: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 11048782
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object BtnRisiSignale: TButton
            Left = 415
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Risi'
            TabOrder = 41
            OnClick = BtnRisiSignaleClick
          end
          object BtnStartAI: TButton
            Left = 171
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Start'
            TabOrder = 42
            OnClick = BtnStartAIClick
          end
          object BtnStopAI: TButton
            Left = 252
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Stop'
            TabOrder = 43
            OnClick = BtnStopAIClick
          end
          object Button24: TButton
            Left = 496
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Risi n povp'
            TabOrder = 44
            OnClick = Button24Click
          end
          object EdPovp: TEdit
            Left = 577
            Top = 5
            Width = 45
            Height = 21
            TabOrder = 45
            Text = '100'
          end
          object CbVsakaDeseta: TCheckBox
            Left = 420
            Top = 27
            Width = 97
            Height = 17
            Caption = 'vsakadeseta'
            Checked = True
            State = cbChecked
            TabOrder = 46
          end
          object Button27: TButton
            Left = 164
            Top = 514
            Width = 75
            Height = 25
            Caption = 'Meri'
            TabOrder = 47
            OnClick = Button27Click
          end
          object Button1: TButton
            Left = 637
            Top = 3
            Width = 75
            Height = 25
            Caption = 'Risi'
            TabOrder = 48
            OnClick = Button1Click
          end
          object Button4: TButton
            Left = 405
            Top = 514
            Width = 75
            Height = 25
            Caption = 'Meri Ke'
            TabOrder = 49
            OnClick = Button4Click
          end
          object Button6: TButton
            Left = 306
            Top = 468
            Width = 75
            Height = 25
            Caption = 'Hitrost/'#269'as'
            TabOrder = 50
            OnClick = Button6Click
          end
          object Chart1: TChart
            Left = 171
            Top = 262
            Width = 600
            Height = 200
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
            BottomAxis.TicksInner.Color = 11119017
            BottomAxis.Title.Font.Name = 'Verdana'
            DepthAxis.Axis.Color = 4210752
            DepthAxis.Grid.Color = 11119017
            DepthAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthAxis.TicksInner.Color = 11119017
            DepthAxis.Title.Font.Name = 'Verdana'
            DepthTopAxis.Axis.Color = 4210752
            DepthTopAxis.Grid.Color = 11119017
            DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
            DepthTopAxis.TicksInner.Color = 11119017
            DepthTopAxis.Title.Font.Name = 'Verdana'
            Hover.Visible = False
            LeftAxis.Axis.Color = 4210752
            LeftAxis.AxisValuesFormat = '#,##0.####'
            LeftAxis.Grid.Color = 11119017
            LeftAxis.LabelsFormat.Font.Name = 'Verdana'
            LeftAxis.LabelsSize = 40
            LeftAxis.TicksInner.Color = 11119017
            LeftAxis.Title.Font.Name = 'Verdana'
            RightAxis.Axis.Color = 4210752
            RightAxis.Grid.Color = 11119017
            RightAxis.LabelsFormat.Font.Name = 'Verdana'
            RightAxis.TicksInner.Color = 11119017
            RightAxis.Title.Font.Name = 'Verdana'
            TopAxis.Axis.Color = 4210752
            TopAxis.Grid.Color = 11119017
            TopAxis.LabelsFormat.Font.Name = 'Verdana'
            TopAxis.TicksInner.Color = 11119017
            TopAxis.Title.Font.Name = 'Verdana'
            View3D = False
            Zoom.AnimatedSteps = 20
            Zoom.Brush.Color = clSilver
            Zoom.Brush.Style = bsSolid
            Zoom.MinimumPixels = 4
            Zoom.Pen.Color = clBlack
            Zoom.Pen.Style = psDot
            Zoom.Pen.Width = 1
            Color = 15724527
            TabOrder = 51
            DefaultCanvas = 'TTeeCanvas3D'
            ColorPaletteIndex = 13
            object Series5: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 10708548
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series6: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 3513587
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series7: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 1330417
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series8: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 11048782
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series9: TFastLineSeries
              Selected.Hover.Visible = True
              LinePen.Color = 7028779
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object Edit1: TEdit
            Left = 170
            Top = 470
            Width = 49
            Height = 21
            TabOrder = 52
            Text = '2'
          end
          object Button7: TButton
            Left = 468
            Top = 468
            Width = 75
            Height = 25
            Caption = 'Tok/hitrost'
            TabOrder = 53
            OnClick = Button7Click
          end
          object Button8: TButton
            Left = 225
            Top = 468
            Width = 75
            Height = 25
            Caption = 'Pot/'#269'as'
            TabOrder = 54
            OnClick = Button8Click
          end
          object Button10: TButton
            Left = 387
            Top = 468
            Width = 75
            Height = 25
            Caption = 'Tok/'#269'as'
            TabOrder = 55
            OnClick = Button10Click
          end
          object BtnVnesiParametreMotorja: TButton
            Left = 599
            Top = 468
            Width = 105
            Height = 25
            Caption = 'Prvi pribli'#382'ek'
            TabOrder = 56
            OnClick = BtnVnesiParametreMotorjaClick
          end
        end
      end
    end
    object StBar5: TStatusBar
      Left = 0
      Top = 791
      Width = 811
      Height = 19
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
      Top = 696
      Width = 811
      Height = 19
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
      Top = 715
      Width = 811
      Height = 19
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
      Top = 734
      Width = 811
      Height = 19
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
      Top = 753
      Width = 811
      Height = 19
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
      Top = 772
      Width = 811
      Height = 19
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
      Width = 811
      Height = 27
      Align = alTop
      BevelOuter = bvLowered
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 7
      DesignSize = (
        811
        27)
      object Label37: TLabel
        Left = 602
        Top = 6
        Width = 48
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Kontroler:'
        ExplicitLeft = 594
      end
      object Label22: TLabel
        Left = 414
        Top = 6
        Width = 98
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Napajalna napetost:'
        ExplicitLeft = 406
      end
      object Label45: TLabel
        Left = 558
        Top = 6
        Width = 6
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'V'
        ExplicitLeft = 550
      end
      object CmbBoxKontrolerji: TComboBox
        Left = 663
        Top = 2
        Width = 143
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        DoubleBuffered = False
        DropDownCount = 50
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Arial'
        Font.Style = []
        ParentDoubleBuffered = False
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnChange = CmbBoxKontrolerjiChange
      end
      object EdVbus: TEdit
        Left = 518
        Top = 2
        Width = 35
        Height = 21
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
