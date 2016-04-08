with Interfaces.Bit_Types; use Interfaces, Interfaces.Bit_Types;

package STMPE811 is

   --  Control Registers
   IOE_REG_SYS_CTRL1    : constant Byte := 16#03#;
   IOE_REG_SYS_CTRL2    : constant Byte := 16#04#;
   IOE_REG_SPI_CFG      : constant Byte := 16#08#;

   --  Touch Panel Registers
   IOE_REG_TSC_CTRL     : constant Byte := 16#40#;
   IOE_REG_TSC_CFG      : constant Byte := 16#41#;
   IOE_REG_WDM_TR_X     : constant Byte := 16#42#;
   IOE_REG_WDM_TR_Y     : constant Byte := 16#44#;
   IOE_REG_WDM_BL_X     : constant Byte := 16#46#;
   IOE_REG_WDM_BL_Y     : constant Byte := 16#48#;
   IOE_REG_FIFO_TH      : constant Byte := 16#4A#;
   IOE_REG_FIFO_STA     : constant Byte := 16#4B#;
   IOE_REG_FIFO_SIZE    : constant Byte := 16#4C#;
   IOE_REG_TSC_DATA_X   : constant Byte := 16#4D#;
   IOE_REG_TSC_DATA_Y   : constant Byte := 16#4F#;
   IOE_REG_TSC_DATA_Z   : constant Byte := 16#51#;
   IOE_REG_TSC_DATA_XYZ : constant Byte := 16#52#;
   IOE_REG_TSC_FRACT_Z  : constant Byte := 16#56#;
   IOE_REG_TSC_DATA     : constant Byte := 16#57#;
   IOE_REG_TSC_I_DRIVE  : constant Byte := 16#58#;
   IOE_REG_TSC_SHIELD   : constant Byte := 16#59#;

   --  IOE GPIO Registers
   IOE_REG_GPIO_SET_PIN : constant Byte := 16#10#;
   IOE_REG_GPIO_CLR_PIN : constant Byte := 16#11#;
   IOE_REG_GPIO_MP_STA  : constant Byte := 16#12#;
   IOE_REG_GPIO_DIR     : constant Byte := 16#13#;
   IOE_REG_GPIO_ED      : constant Byte := 16#14#;
   IOE_REG_GPIO_RE      : constant Byte := 16#15#;
   IOE_REG_GPIO_FE      : constant Byte := 16#16#;
   IOE_REG_GPIO_AF      : constant Byte := 16#17#;

   --  IOE Functions
   IOE_ADC_FCT          : constant Byte := 16#01#;
   IOE_TSC_FCT          : constant Byte := 16#02#;
   IOE_IO_FCT           : constant Byte := 16#04#;

   --  ADC Registers
   IOE_REG_ADC_INT_EN   : constant Byte := 16#0E#;
   IOE_REG_ADC_INT_STA  : constant Byte := 16#0F#;
   IOE_REG_ADC_CTRL1    : constant Byte := 16#20#;
   IOE_REG_ADC_CTRL2    : constant Byte := 16#21#;
   IOE_REG_ADC_CAPT     : constant Byte := 16#22#;
   IOE_REG_ADC_DATA_CH0 : constant Byte := 16#30#;
   IOE_REG_ADC_DATA_CH1 : constant Byte := 16#32#;
   IOE_REG_ADC_DATA_CH2 : constant Byte := 16#34#;
   IOE_REG_ADC_DATA_CH3 : constant Byte := 16#36#;
   IOE_REG_ADC_DATA_CH4 : constant Byte := 16#38#;
   IOE_REG_ADC_DATA_CH5 : constant Byte := 16#3A#;
   IOE_REG_ADC_DATA_CH6 : constant Byte := 16#3B#;
   IOE_REG_ADC_DATA_CH7 : constant Byte := 16#3C#;

   --  Interrupt Control Registers
   IOE_REG_INT_CTRL     : constant Byte := 16#09#;
   IOE_REG_INT_EN       : constant Byte := 16#0A#;
   IOE_REG_INT_STA      : constant Byte := 16#0B#;
   IOE_REG_GPIO_INT_EN  : constant Byte := 16#0C#;
   IOE_REG_GPIO_INT_STA : constant Byte := 16#0D#;

   --  touch Panel Pins
   TOUCH_YD             : constant Byte := 16#02#;
   TOUCH_XD             : constant Byte := 16#04#;
   TOUCH_YU             : constant Byte := 16#08#;
   TOUCH_XU             : constant Byte := 16#10#;
   TOUCH_IO_ALL         : constant Byte :=
     TOUCH_YD or TOUCH_XD or TOUCH_YU or TOUCH_XU;

end STMPE811;
