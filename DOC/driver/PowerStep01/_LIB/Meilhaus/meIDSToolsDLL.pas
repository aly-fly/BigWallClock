//==============================================================================
//Copyright(c), Meilhaus Electronic GmbH
//              http://www.meilhaus.de
//              support@meilhaus.de
//
//Source File : meIDSToolsDLL.pas
//              contains a collection of routines to carry out common tasks using the ME-iDS system
//              The library is located in the folder:
//              %ProgramFiles%\Meilhaus Electronic\ME-iDS\[me-ids-version]\System\ME-iDS (Driver)
//              replace [me-ids-version] with the installed version
//              of the ME-iDS, e.g.: 02.00.02.000
//              See ME-iDS help file for more information
//Note        : import library for 32bit: meIDSTools.dll
//              import library for 64bit: meIDSTools64.dll
//              
//==============================================================================
unit meIDSToolsDLL

interface

uses
    SysUtils;

const

{$IFDEF WIN32}
  MEIDSTOOLS_DLL = 'meIDSTools.dll';               //import dll for meIDSTools library (32bit)
{$ENDIF}

{$IFDEF WIN64}
  MEIDSTOOLS_DLL = 'meIDSTools64.dll';             //import dll for meIDSTools library (64bit)
{$ENDIF}

type

//==============================================================================
//  Functions to access the meIDSTools library
//==============================================================================
function meIDSToolsWaveGen(iDevice: Integer; iSubdevice: Integer; iUnit: Integer; iShape: Integer; dAmplitude: Double; dOffset: Double; var pdFrequency: Double): Integer; cdecl; external MEIDSTOOLS_DLL;

//==============================================================================
//  constants
//==============================================================================
const
//==============================================================================
//  Error codes
//==============================================================================
    MEIDS_TOOLS_ERRNO_SUCCESS                           = 0;
    MEIDS_TOOLS_ERRNO_WAVEGEN_SIGNAL_OUT_OF_RANGE       = 10001;
    MEIDS_TOOLS_ERRNO_WAVEGEN_FREQUENCY_OUT_OF_RANGE    = 10002;

//==============================================================================
// Signal forms for the function meIDSToolsWaveGen - Parameter iShape
//==============================================================================
    MEIDS_TOOLS_WAVEGEN_SHAPE_RECTANGLE                 = $10010001;
    MEIDS_TOOLS_WAVEGEN_SHAPE_TRIANGLE                  = $10010002;
    MEIDS_TOOLS_WAVEGEN_SHAPE_SINUS                     = $10010003;
    MEIDS_TOOLS_WAVEGEN_SHAPE_COSINUS                   = $10010004;
    MEIDS_TOOLS_WAVEGEN_SHAPE_POS_RAMP                  = $10010005;
    MEIDS_TOOLS_WAVEGEN_SHAPE_NEG_RAMP                  = $10010006;


    
implementation

end.
