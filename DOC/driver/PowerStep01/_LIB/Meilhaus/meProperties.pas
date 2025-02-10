//==============================================================================
//Copyright(c), Meilhaus Electronic GmbH
//              http://www.meilhaus.de
//              support@meilhaus.de
//
//Source File : meProperties.pas
//            : 2012-11-05 created from meproperties.h
//              defines of property names
//===============================================================================
unit meProperties;

interface

uses
    SysUtils;

const

  //==================================================================
  //  System properties
  //==================================================================

  ME_CONTAINER_NAME_ROOT = '\\';  // Root container (system container)
  
  ME_ATTRIBUTE_NAME_NUMBER_OF_ELEMENTS    = 'NumberOfElements';
  ME_ATTRIBUTE_NAME_PROPERTY_NAME         = 'PropertyName';
  ME_ATTRIBUTE_NAME_PROPERTY_TYPE         = 'PropertyType';
  ME_ATTRIBUTE_NAME_PROPERTY_ACCESS       = 'PropertyAccess';
  ME_ATTRIBUTE_NAME_PROPERTY_DESCRIPTION  = 'PropertyDescription';
  ME_ATTRIBUTE_NAME_MIN_VALUE             = 'MinValue';
  ME_ATTRIBUTE_NAME_MAX_VALUE             = 'MaxValue';
  ME_ATTRIBUTE_NAME_LENGTH                = 'Length';
  ME_ATTRIBUTE_NAME_MAX_LENGTH            = 'MaxLength';
  ME_ATTRIBUTE_NAME_NUMBER_OF_SELECTIONS  = 'NumberOfSelections';
  ME_ATTRIBUTE_NAME_PREFIX_SELECTION      = 'Selection';    // The selection with index # is 'Selection#';
 
  
  //==================================================================
  //  System properties and containers
  //==================================================================

  ME_PROPERTY_NAME_LIBRARY_VERSION        = 'LibraryVersion';
  ME_PROPERTY_NAME_MAIN_DRIVER_VERSION    = 'MainDriverVersion';
  ME_PROPERTY_NAME_NUMBER_OF_DEVICES      = 'NumberOfDevices';
  ME_CONTAINER_NAME_DEVICES               = 'Devices';

  //==================================================================
  //  General device properties and containers - not device specific
  //==================================================================

  ME_CONTAINER_NAME_PREFIX_DEVICE         = 'Device';    // The container name for the device with index # is 'Device#';
  ME_PROPERTY_NAME_NAME                   = 'Name';
  ME_PROPERTY_NAME_DRIVER_NAME            = 'DriverName';
  ME_PROPERTY_NAME_DRIVER_VERSION         = 'DriverVersion';
  ME_PROPERTY_NAME_DESCRIPTION            = 'Description';
  ME_PROPERTY_NAME_SERIAL_NUMBER          = 'SerialNumber';
  ME_PROPERTY_NAME_BUS_TYPE               = 'BusType';
  ME_PROPERTY_NAME_ACCESS_TYPE            = 'AccessType';
  ME_PROPERTY_NAME_PLUGGED                = 'Plugged';
  ME_PROPERTY_NAME_FIRMWARE_SELECTABLE    = 'FirmwareSelectable';
  ME_PROPERTY_NAME_CURRENT_FIRMWARE_ID    = 'CurrentFirmwareID';
  ME_PROPERTY_NAME_NUMBER_OF_SUBDEVICES   = 'NumberOfSubdevices';
  ME_CONTAINER_NAME_SUBDEVICES            = 'Subdevices';
  

  //==================================================================
  // Additional properties for PCI devices
  //==================================================================

  ME_PROPERTY_NAME_PCI_VENDOR_ID          = 'PCIVendorID';
  ME_PROPERTY_NAME_PCI_DEVICE_ID          = 'PCIDeviceID';
  ME_PROPERTY_NAME_PCI_BUS_NUMBER         = 'PCIBusNumber';
  ME_PROPERTY_NAME_PCI_SLOT_NUMBER        = 'PCISlotNumber';
  ME_PROPERTY_NAME_PCI_FUNCTION_NUMBER    = 'PCIFunctionNumber';
  

  //==================================================================
  // General sub-device properties and containers - not sub-device specific
  //==================================================================

  ME_CONTAINER_NAME_PREFIX_SUBDEVICE      = 'Subdevice';    // The container name for the sub-device with index # is 'Subdevice#';
  ME_PROPERTY_NAME_TYPE                   = 'Type';
  ME_PROPERTY_NAME_SUBTYPE                = 'Subtype';
  ME_PROPERTY_NAME_NUMBER_OF_CHANNELS     = 'NumberOfChannels';
  ME_PROPERTY_NAME_CONFIGURABLE           = 'Configurable';
  ME_PROPERTY_NAME_NUMBER_OF_CONFIGURATIONS = 'NumberOfConfigurations';
  ME_PROPERTY_NAME_CURRENT_CONFIGURATION  = 'CurrentConfiguration';
  ME_CONTAINER_NAME_CHANNELS              = 'Channels';
  ME_CONTAINER_NAME_PREFIX_CHANNEL        = 'Channel'; // The container name for the channel with index # is 'Channel#';
  ME_CONTAINER_NAME_CONFIGURATIONS        = 'Configurations';
  ME_CONTAINER_NAME_PREFIX_CONFIGURATION  = 'Configuration';    // The container name for the configuration with index # is 'Configuration#';

  //==================================================================
  // Configuration properties
  //==================================================================

  ME_PROPERTY_NAME_SUBDEVICE_TYPE         = 'SubdeviceType';
  ME_PROPERTY_NAME_SUBDEVICE_SUBTYPE      = 'SubdeviceSubtype';
  ME_PROPERTY_NAME_SUBDEVICE_NUMBER_OF_CHANNELS = 'SubdeviceNumberOfChannels';

  //==================================================================
  // ME-5100 and ME-5001 - additional device properties
  //==================================================================

  ME_PROPERTY_NAME_IO_PIN_VOLTAGE_LEVEL   = 'IOPinVoltageLevel';
  ME_PROPERTY_NAME_SUBDEVICES_0_AND_1_TERMINATED = 'Subdevice0And1Terminated';
  ME_PROPERTY_NAME_SUBDEVICES_2_AND_3_TERMINATED = 'Subdevice2And3Terminated';

  //==================================================================
  // Additional sub-device properties for various sub-device types
  //==================================================================

  ME_PROPERTY_NAME_TERMINATED             = 'Terminated';
  ME_PROPERTY_NAME_SYSTEM_CLOCK_FREQUENCY = 'SystemClockFrequency';

  //==================================================================
  // Additional sub-device properties and containers for DI and DO sub-device types
  //==================================================================

  ME_PROPERTY_NAME_TRIGGER_TYPE           = 'TriggerType';
  ME_PROPERTY_NAME_PREFIX_RISING_EDGE_BIT = 'RisingEdgeBit';    // The name for the trigger condition on bit # is 'RisingEdgeBit#';
  ME_PROPERTY_NAME_PREFIX_FALLING_EDGE_BIT = 'FallingEdgeBit';    // The name for the trigger condition on bit # is 'FallngEdgeBit#';
  ME_PROPERTY_NAME_INTERNAL_BUFFER_SIZE   = 'InternalBufferSize';
  ME_PROPERTY_NAME_SAMPLE_FREQUENCY       = 'SampleFrequency';
  ME_PROPERTY_NAME_SAMPLE_TIME            = 'SampleTime';
  ME_PROPERTY_NAME_START_TRIGGER_TYPE     = 'StartTriggerType';
  ME_PROPERTY_NAME_CONV_TRIGGER_TYPE      = 'ConvTriggerType';
  ME_PROPERTY_NAME_STOP_TRIGGER_TYPE      = 'StopTriggerType';
  ME_PROPERTY_NAME_START_STOP_PATTERN     = 'StartStopPattern';
  ME_PROPERTY_NAME_STOP_ON_COUNT          = 'StopOnCount';
  ME_PROPERTY_NAME_STOP_COUNT             = 'StopCount';
  ME_CONTAINER_NAME_INTERRUPT_CONDITION   = 'InterruptCondition';
  ME_CONTAINER_NAME_SINGLE_CONFIGURATION  = 'SingleConfiguration';
  ME_CONTAINER_NAME_EXT_DIGITAL_TRIGGER_CONDITION = 'ExtDigitalTriggerCondition';
  ME_CONTAINER_NAME_STREAMING_CONFIGURATION = 'StreamingConfiguration';
  ME_CONTAINER_NAME_START_AND_CONV_TRIGGER_CONDITION = 'StartAndConvTriggerCondition';
  ME_CONTAINER_NAME_STOP_TRIGGER_CONDITION = 'StopTriggerCondition';
  ME_CONTAINER_NAME_IRQ_CONFIGURATION      = 'IRQConfiguration';

  //==================================================================
  // Additional sub-device properties for AI sub-device types
  //==================================================================

  ME_PROPERTY_NAME_CALIBRATION             = 'Calibration';
  ME_PROPERTY_NAME_RISING_EDGE_TRIGGER_A1  = 'RisingEdgeTriggerA1';
  ME_PROPERTY_NAME_FALLING_EDGE_TRIGGER_A1 = 'FallingEdgeTriggerA1';
  ME_PROPERTY_NAME_RISING_EDGE_TRIGGER_A2  = 'RisingEdgeTriggerA2';
  ME_PROPERTY_NAME_FALLING_EDGE_TRIGGER_A2 = 'FallingEdgeTriggerA2';
  ME_PROPERTY_NAME_ACQUIRE_CHANNEL         = 'AcquireChannel';

  //==================================================================
  // Additional sub-device properties and containers for DI sub-device types
  //==================================================================

  ME_PROPERTY_NAME_RISING_EDGE_TRIGGER_A   = 'RisingEdgeTriggerA';
  ME_PROPERTY_NAME_FALLING_EDGE_TRIGGER_A  = 'FallingEdgeTriggerA';
  ME_PROPERTY_NAME_USE_INTERNAL_TEST_COUNTER = 'UseInternalTestCounter';
  ME_PROPERTY_NAME_TRANSFER_SIZE          = 'TransferSize';
  ME_PROPERTY_NAME_IRQ_SOURCE             = 'IRQSource';
  ME_PROPERTY_NAME_BIT_PATTERN            = 'BitPattern';
  ME_PROPERTY_NAME_BIT_PATTERN_FILTERING  = 'BitPatternFiltering';
  ME_PROPERTY_CONTAINER_BIT_MASK          = 'BitMask';

  //==================================================================
  // Additional sub-device properties and containers for DO sub-device types
  //==================================================================

  ME_PROPERTY_NAME_RISING_EDGE_TRIGGER_B  = 'RisingEdgeTriggerB';
  ME_PROPERTY_NAME_FALLING_EDGE_TRIGGER_B = 'FallingEdgeTriggerB';
  ME_PROPERTY_NAME_IRQ_ON_EXCESS_TEMPERATURE = 'IRQOnExcessTemperature';
  ME_PROPERTY_NAME_IRQ_ON_NORMAL_TEMPERATURE = 'IRQOnNormalTemperature';
  ME_PROPERTY_NAME_STOP_PATTERN           = 'StopPattern';
  ME_PROPERTY_NAME_WRAPAROUND             = 'Wraparound';
  ME_PROPERTY_NAME_WRAPAROUND_LOOPS       = 'WraparoundLoops';

  //==================================================================
  // Additional sub-device properties and containers for DO and FO sub-device types
  //==================================================================

  ME_PROPERTY_NAME_OUTPUT_MODE            = 'OutputMode';

  //==================================================================
  // Additional sub-device properties and containers for DIO sub-device types
  //==================================================================

  ME_PROPERTY_NAME_DIRECTION              = 'Direction';

  //==================================================================
  // Additional sub-device properties FI sub-device types
  //==================================================================

  ME_PROPERTY_NAME_MIN_MEASURABLE_TOTAL_TICKS = 'MinMeasurableTotalTicks';
  ME_PROPERTY_NAME_MAX_MEASURABLE_TOTAL_TICK  = 'MaxMeasurableTotalTicks';
  ME_PROPERTY_NAME_MIN_MEASURABLE_FIRST_PHASE_TICKS = 'MinMeasurableFirstPhaseTicks';
  ME_PROPERTY_NAME_MAX_MEASURABLE_FIRST_PHASE_TICKS = 'MaxMeasurableFirstPhaseTicks';
  ME_PROPERTY_NAME_MIN_MEASURABLE_TOTAL_TIME  = 'MinMeasurableTotalTime';
  ME_PROPERTY_NAME_MAX_MEASURABLE_TOTAL_TIME  = 'MaxMeasurableTotalTime';
  ME_PROPERTY_NAME_MIN_MEASURABLE_FIRST_PHASE_TIME = 'MinMeasurableFirstPhaseTime';
  ME_PROPERTY_NAME_MAX_MEASURABLE_FIRST_PHASE_TIME = 'MaxMeasurableFirstPhaseTime';

  //==================================================================
  // Additional sub-device properties for FO sub-device types
  //==================================================================

  ME_PROPERTY_NAME_MIN_TOTAL_TICKS        = 'MinTotalTicks';
  ME_PROPERTY_NAME_MAX_TOTAL_TICK         = 'MaxTotalTicks';
  ME_PROPERTY_NAME_MIN_FIRST_PHASE_TICKS  = 'MinFirstPhaseTicks';
  ME_PROPERTY_NAME_MAX_FIRST_PHASE_TICKS  = 'MaxFirstPhaseTicks';
  ME_PROPERTY_NAME_MIN_TOTAL_TIME         = 'MinTotalTime';
  ME_PROPERTY_NAME_MAX_TOTAL_TIME         = 'MaxTotalTime';
  ME_PROPERTY_NAME_MIN_FIRST_PHASE_TIME   = 'MinFirstPhaseTime';
  ME_PROPERTY_NAME_MAX_FIRST_PHASE_TIME   = 'MaxFirstPhaseTime';

  //==================================================================
  // FO sub-device channel properties
  //==================================================================

  ME_PROPERTY_NAME_INVERTED               = 'Inverted';
  ME_PROPERTY_NAME_SYNCHRONOUS_START      = 'SynchronousStart';
  ME_PROPERTY_NAME_SOFT_START             = 'SoftStart';
  
  //==================================================================
  // Counter sub-devices - additional sub-device properties
  //==================================================================

  ME_PROPERTY_NAME_WIDTH_IN_BITS          = 'WidthInBits';
  ME_PROPERTY_NAME_CLOCK_SOURCE           = 'ClockSource';
  ME_PROPERTY_NAME_COUNTER_MODE           = 'CounterMode';
  
implementation

end.
