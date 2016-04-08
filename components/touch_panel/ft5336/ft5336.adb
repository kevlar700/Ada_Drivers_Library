with Ada.Unchecked_Conversion;

package body FT5336 is


   pragma Warnings (Off, "* is not referenced");

   --------------------------------------%----------------------
   -- Definitions for FT5336 I2C register addresses on 8 bit --
   ------------------------------------------------------------

   --  Current mode register of the FT5336 (R/W)
   FT5336_DEV_MODE_REG                 : constant Unsigned_8 := 16#00#;

   --  Possible values of FT5336_DEV_MODE_REG
   FT5336_DEV_MODE_WORKING             : constant Unsigned_8 := 16#00#;
   FT5336_DEV_MODE_FACTORY             : constant Unsigned_8 := 16#04#;

   FT5336_DEV_MODE_MASK                : constant Unsigned_8 := 16#07#;
   FT5336_DEV_MODE_SHIFT               : constant Unsigned_8 := 16#04#;

   --  Gesture ID register
   FT5336_GEST_ID_REG                  : constant Unsigned_8 := 16#01#;

   --  Possible values of FT5336_GEST_ID_REG
   FT5336_GEST_ID_NO_GESTURE           : constant Unsigned_8 := 16#00#;
   FT5336_GEST_ID_MOVE_UP              : constant Unsigned_8 := 16#10#;
   FT5336_GEST_ID_MOVE_RIGHT           : constant Unsigned_8 := 16#14#;
   FT5336_GEST_ID_MOVE_DOWN            : constant Unsigned_8 := 16#18#;
   FT5336_GEST_ID_MOVE_LEFT            : constant Unsigned_8 := 16#1C#;
   FT5336_GEST_ID_SINGLE_CLICK         : constant Unsigned_8 := 16#20#;
   FT5336_GEST_ID_DOUBLE_CLICK         : constant Unsigned_8 := 16#22#;
   FT5336_GEST_ID_ROTATE_CLOCKWISE     : constant Unsigned_8 := 16#28#;
   FT5336_GEST_ID_ROTATE_C_CLOCKWISE   : constant Unsigned_8 := 16#29#;
   FT5336_GEST_ID_ZOOM_IN              : constant Unsigned_8 := 16#40#;
   FT5336_GEST_ID_ZOOM_OUT             : constant Unsigned_8 := 16#49#;

   --  Touch Data Status register : gives number of active touch points (0..5)
   FT5336_TD_STAT_REG                  : constant Unsigned_8 := 16#02#;

   --  Values related to FT5336_TD_STAT_REG
   FT5336_TD_STAT_MASK                 : constant Unsigned_8 := 16#0F#;
   FT5336_TD_STAT_SHIFT                : constant Unsigned_8 := 16#00#;

   --  Values Pn_XH and Pn_YH related
   FT5336_TOUCH_EVT_FLAG_PRESS_DOWN    : constant Unsigned_8 := 16#00#;
   FT5336_TOUCH_EVT_FLAG_LIFT_UP       : constant Unsigned_8 := 16#01#;
   FT5336_TOUCH_EVT_FLAG_CONTACT       : constant Unsigned_8 := 16#02#;
   FT5336_TOUCH_EVT_FLAG_NO_EVENT      : constant Unsigned_8 := 16#03#;

   FT5336_TOUCH_EVT_FLAG_SHIFT         : constant Unsigned_8 := 16#06#;
   FT5336_TOUCH_EVT_FLAG_MASK          : constant Unsigned_8 := 2#1100_0000#;

   FT5336_TOUCH_POS_MSB_MASK           : constant Unsigned_8 := 16#0F#;
   FT5336_TOUCH_POS_MSB_SHIFT          : constant Unsigned_8 := 16#00#;

   --  Values Pn_XL and Pn_YL related
   FT5336_TOUCH_POS_LSB_MASK           : constant Unsigned_8 := 16#FF#;
   FT5336_TOUCH_POS_LSB_SHIFT          : constant Unsigned_8 := 16#00#;


   --  Values Pn_WEIGHT related
   FT5336_TOUCH_WEIGHT_MASK            : constant Unsigned_8 := 16#FF#;
   FT5336_TOUCH_WEIGHT_SHIFT           : constant Unsigned_8 := 16#00#;


   --  Values related to FT5336_Pn_MISC_REG
   FT5336_TOUCH_AREA_MASK              : constant Unsigned_8 := 2#0100_0000#;
   FT5336_TOUCH_AREA_SHIFT             : constant Unsigned_8 := 16#04#;

   type FT5336_Pressure_Registers is record
      XH_Reg     : Unsigned_8;
      XL_Reg     : Unsigned_8;
      YH_Reg     : Unsigned_8;
      YL_Reg     : Unsigned_8;
      --  Touch Pressure register value (R)
      Weight_Reg : Unsigned_8;
      --  Touch area register
      Misc_Reg   : Unsigned_8;
   end record;

   FT5336_Px_Regs                : constant array (Unsigned_8 range <>)
                                      of FT5336_Pressure_Registers  :=
                                     (1  => (XH_Reg     => 16#03#,
                                             XL_Reg     => 16#04#,
                                             YH_Reg     => 16#05#,
                                             YL_Reg     => 16#06#,
                                             Weight_Reg => 16#07#,
                                             Misc_Reg   => 16#08#),
                                      2  => (XH_Reg     => 16#09#,
                                             XL_Reg     => 16#0A#,
                                             YH_Reg     => 16#0B#,
                                             YL_Reg     => 16#0C#,
                                             Weight_Reg => 16#0D#,
                                             Misc_Reg   => 16#0E#),
                                      3  => (XH_Reg     => 16#0F#,
                                             XL_Reg     => 16#10#,
                                             YH_Reg     => 16#11#,
                                             YL_Reg     => 16#12#,
                                             Weight_Reg => 16#13#,
                                             Misc_Reg   => 16#14#),
                                      4  => (XH_Reg     => 16#15#,
                                             XL_Reg     => 16#16#,
                                             YH_Reg     => 16#17#,
                                             YL_Reg     => 16#18#,
                                             Weight_Reg => 16#19#,
                                             Misc_Reg   => 16#1A#),
                                      5  => (XH_Reg     => 16#1B#,
                                             XL_Reg     => 16#1C#,
                                             YH_Reg     => 16#1D#,
                                             YL_Reg     => 16#1E#,
                                             Weight_Reg => 16#1F#,
                                             Misc_Reg   => 16#20#),
                                      6  => (XH_Reg     => 16#21#,
                                             XL_Reg     => 16#22#,
                                             YH_Reg     => 16#23#,
                                             YL_Reg     => 16#24#,
                                             Weight_Reg => 16#25#,
                                             Misc_Reg   => 16#26#),
                                      7  => (XH_Reg     => 16#27#,
                                             XL_Reg     => 16#28#,
                                             YH_Reg     => 16#29#,
                                             YL_Reg     => 16#2A#,
                                             Weight_Reg => 16#2B#,
                                             Misc_Reg   => 16#2C#),
                                      8  => (XH_Reg     => 16#2D#,
                                             XL_Reg     => 16#2E#,
                                             YH_Reg     => 16#2F#,
                                             YL_Reg     => 16#30#,
                                             Weight_Reg => 16#31#,
                                             Misc_Reg   => 16#32#),
                                      9  => (XH_Reg     => 16#33#,
                                             XL_Reg     => 16#34#,
                                             YH_Reg     => 16#35#,
                                             YL_Reg     => 16#36#,
                                             Weight_Reg => 16#37#,
                                             Misc_Reg   => 16#38#),
                                      10 => (XH_Reg     => 16#39#,
                                             XL_Reg     => 16#3A#,
                                             YH_Reg     => 16#3B#,
                                             YL_Reg     => 16#3C#,
                                             Weight_Reg => 16#3D#,
                                             Misc_Reg   => 16#3E#));

   --  Threshold for touch detection
   FT5336_TH_GROUP_REG                 : constant Unsigned_8 := 16#80#;

   --  Values FT5336_TH_GROUP_REG : threshold related
   FT5336_THRESHOLD_MASK               : constant Unsigned_8 := 16#FF#;
   FT5336_THRESHOLD_SHIFT              : constant Unsigned_8 := 16#00#;

   --  Filter function coefficients
   FT5336_TH_DIFF_REG                  : constant Unsigned_8 := 16#85#;

   --  Control register
   FT5336_CTRL_REG                     : constant Unsigned_8 := 16#86#;

   --  Values related to FT5336_CTRL_REG

   --  Will keep the Active mode when there is no touching
   FT5336_CTRL_KEEP_ACTIVE_MODE        : constant Unsigned_8 := 16#00#;

   --  Switching from Active mode to Monitor mode automatically when there
   --  is no touching
   FT5336_CTRL_KEEP_AUTO_SWITCH_MONITOR_MODE : constant Unsigned_8 := 16#01#;

   --  The time period of switching from Active mode to Monitor mode when
   --  there is no touching
   FT5336_TIMEENTERMONITOR_REG               : constant Unsigned_8 := 16#87#;

   --  Report rate in Active mode
   FT5336_PERIODACTIVE_REG             : constant Unsigned_8 := 16#88#;

   --  Report rate in Monitor mode
   FT5336_PERIODMONITOR_REG            : constant Unsigned_8 := 16#89#;

   --  The value of the minimum allowed angle while Rotating gesture mode
   FT5336_RADIAN_VALUE_REG             : constant Unsigned_8 := 16#91#;

   --  Maximum offset while Moving Left and Moving Right gesture
   FT5336_OFFSET_LEFT_RIGHT_REG        : constant Unsigned_8 := 16#92#;

   --  Maximum offset while Moving Up and Moving Down gesture
   FT5336_OFFSET_UP_DOWN_REG           : constant Unsigned_8 := 16#93#;

   --  Minimum distance while Moving Left and Moving Right gesture
   FT5336_DISTANCE_LEFT_RIGHT_REG      : constant Unsigned_8 := 16#94#;

   --  Minimum distance while Moving Up and Moving Down gesture
   FT5336_DISTANCE_UP_DOWN_REG         : constant Unsigned_8 := 16#95#;

   --  Maximum distance while Zoom In and Zoom Out gesture
   FT5336_DISTANCE_ZOOM_REG            : constant Unsigned_8 := 16#96#;

   --  High 8-bit of LIB Version info
   FT5336_LIB_VER_H_REG                : constant Unsigned_8 := 16#A1#;

   --  Low 8-bit of LIB Version info
   FT5336_LIB_VER_L_REG                : constant Unsigned_8 := 16#A2#;

   --  Chip Selecting
   FT5336_CIPHER_REG                   : constant Unsigned_8 := 16#A3#;

   --  Interrupt mode register (used when in interrupt mode)
   FT5336_GMODE_REG                    : constant Unsigned_8 := 16#A4#;

   FT5336_G_MODE_INTERRUPT_MASK        : constant Unsigned_8 := 16#03#;

   --  Possible values of FT5336_GMODE_REG
   FT5336_G_MODE_INTERRUPT_POLLING     : constant Unsigned_8 := 16#00#;
   FT5336_G_MODE_INTERRUPT_TRIGGER     : constant Unsigned_8 := 16#01#;

   --  Current power mode the FT5336 system is in (R)
   FT5336_PWR_MODE_REG                 : constant Unsigned_8 := 16#A5#;

   --  FT5336 firmware version
   FT5336_FIRMID_REG                   : constant Unsigned_8 := 16#A6#;

   --  FT5336 Chip identification register
   FT5336_CHIP_ID_REG                  : constant Unsigned_8 := 16#A8#;

   --   Possible values of FT5336_CHIP_ID_REG
   FT5336_ID_VALUE                     : constant Unsigned_8 := 16#51#;

   --  Release code version
   FT5336_RELEASE_CODE_ID_REG          : constant Unsigned_8 := 16#AF#;

   --  Current operating mode the FT5336 system is in (R)
   FT5336_STATE_REG                    : constant Unsigned_8 := 16#BC#;

   pragma Warnings (On, "* is not referenced");

   -------------
   -- Read_Id --
   -------------

   function Check_Id return Boolean
   is
      Id     : Unsigned_8;
      Status : I2C_Status;
   begin
      for J in 1 .. 3 loop
         Id := IO_Read (FT5336_CHIP_ID_REG, Status);

         if Id = FT5336_ID_VALUE then
            return True;
         end if;

         if Status = I2C_Error then
            return False;
         end if;
      end loop;

      return False;
   end Check_Id;

   ---------------------------
   -- TP_Set_Use_Interrupts --
   ---------------------------

   procedure TP_Set_Use_Interrupts (Enabled : Boolean)
   is
      Reg_Value : Unsigned_8 := 0;
      Status    : I2C_Status with Unreferenced;
   begin
      if Enabled then
         Reg_Value := FT5336_G_MODE_INTERRUPT_TRIGGER;
      else
         Reg_Value := FT5336_G_MODE_INTERRUPT_POLLING;
      end if;

      IO_Write (FT5336_GMODE_REG, Reg_Value, Status);
   end TP_Set_Use_Interrupts;

   -------------------------
   -- Active_Touch_Points --
   -------------------------

   function Active_Touch_Points return Touch_Identifier
   is
     Status   : I2C_Status;
     Nb_Touch : Unsigned_8 := 0;
   begin
      Nb_Touch := IO_Read (FT5336_TD_STAT_REG, Status);

      if Status /= Ok then
         return 0;
      end if;

      Nb_Touch := Nb_Touch and FT5336_TD_STAT_MASK;

      if Nb_Touch > FT5336_Px_Regs'Last then
         --  Overflow: set to 0
         Nb_Touch := 0;
      end if;

      return Natural (Nb_Touch);
   end Active_Touch_Points;

   ---------------------
   -- Get_Touch_Point --
   ---------------------

   function Get_Touch_Point (Touch_Id : Touch_Identifier) return Touch_Point
   is
      type Short_HL_Type is record
         High, Low : Unsigned_8;
      end record with Size => 16;
      for Short_HL_Type use record
         High at 1 range 0 .. 7;
         Low  at 0 range 0 .. 7;
      end record;

      function To_Short is
        new Ada.Unchecked_Conversion (Short_HL_Type, Unsigned_16);

      Ret    : Touch_Point;
      Regs   : FT5336_Pressure_Registers;
      Tmp    : Short_HL_Type;
      Status : I2C_Status;

   begin
      --  X/Y are swaped from the screen coordinates

      Regs := FT5336_Px_Regs (Unsigned_8 (Touch_Id));

      Tmp.Low := IO_Read (Regs.XL_Reg, Status);

      if Status /= Ok then
         return (0, 0, 0);
      end if;

      Tmp.High := IO_Read (Regs.XH_Reg, Status) and FT5336_TOUCH_POS_MSB_MASK;

      if Status /= Ok then
         return (0, 0, 0);
      end if;

      Ret.Y := To_Short (Tmp);

      Tmp.Low := IO_Read (Regs.YL_Reg, Status);

      if Status /= Ok then
         return (0, 0, 0);
      end if;

      Tmp.High := IO_Read (Regs.YH_Reg, Status) and FT5336_TOUCH_POS_MSB_MASK;

      if Status /= Ok then
         return (0, 0, 0);
      end if;

      Ret.X := To_Short (Tmp);

      Ret.Weight := IO_Read (Regs.Weight_Reg, Status);

      if Status /= Ok then
         Ret.Weight := 0;
      end if;

      return Ret;
   end Get_Touch_Point;

end FT5336;
