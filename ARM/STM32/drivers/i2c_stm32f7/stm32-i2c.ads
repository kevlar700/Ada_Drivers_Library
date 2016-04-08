------------------------------------------------------------------------------
--                                                                          --
--               Standard Peripheral Library for STM32 Targets              --
--                                                                          --
--             Copyright (C) 2014, Free Software Foundation, Inc.           --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This file provides definitions for the STM32F7 (ARM Cortex M7F
--  from ST Microelectronics) Inter-Integrated Circuit (I2C) facility.

with STM32_SVD.I2C;
with HAL.I2C;       use HAL.I2C;

package STM32.I2C is

   type I2C_Direction is (Transmitter, Receiver);

   type I2C_Addressing_Mode is
     (Addressing_Mode_7bit,
      Addressing_Mode_10bit);

   type I2C_Configuration is record
      Clock_Speed              : Word;
      Addressing_Mode          : I2C_Addressing_Mode;
      Own_Address              : UInt10;

      --  an I2C general call dispatches the same data to all connected
      --  devices.
      General_Call_Enabled     : Boolean := False;

      --  Clock stretching is a mean for a slave device to slow down the
      --  i2c clock in order to process the communication.
      Clock_Stretching_Enabled : Boolean := True;
   end record;

--     type I2C_Data is array (Natural range <>) of Byte;

   I2C_Timeout : exception;
   I2C_Error   : exception;

   type I2C_Port is new HAL.I2C.I2C_Controller with private;

   function As_I2C_Port
     (Port : access STM32_SVD.I2C.I2C_Peripheral) return I2C_Port;
   --  Returns an I2C_Port structure from the base I2C Peripheral

   function Get_Peripheral
     (Port : I2C_Port) return STM32_SVD.I2C.I2C_Peripheral;
   --  Retrieve the I2C_Peripheral form the I2C_Port structure
   --  This accessor is required by STM32.Device, but shouldn't be used for
   --  general purpose I2C protocol usage.

   function Port_Enabled (Port : I2C_Port) return Boolean
     with Inline;

   procedure Configure
     (Port          : in out I2C_Port;
      Configuration : I2C_Configuration)
     with Pre  => not Is_Configured (Port),
          Post => Is_Configured (Port);

   overriding
   function Is_Configured (Port : I2C_Port) return Boolean;

   overriding
   procedure Master_Transmit
     (Port    : in out I2C_Port;
      Addr    : I2C_Address;
      Data    : I2C_Data;
      Status  : out I2C_Status;
      Timeout : Natural := 1000)
     with Pre => Is_Configured (Port);

   overriding
   procedure Master_Receive
     (Port    : in out I2C_Port;
      Addr    : I2C_Address;
      Data    : out I2C_Data;
      Status  : out I2C_Status;
      Timeout : Natural := 1000)
     with Pre => Is_Configured (Port);

   overriding
   procedure Mem_Write
     (Port          : in out I2C_Port;
      Addr          : I2C_Address;
      Mem_Addr      : Short;
      Mem_Addr_Size : I2C_Memory_Address_Size;
      Data          : I2C_Data;
      Status        : out I2C_Status;
      Timeout       : Natural := 1000)
     with Pre => Is_Configured (Port);

   overriding
   procedure Mem_Read
     (Port          : in out I2C_Port;
      Addr          : I2C_Address;
      Mem_Addr      : Short;
      Mem_Addr_Size : I2C_Memory_Address_Size;
      Data          : out I2C_Data;
      Status        : out I2C_Status;
      Timeout       : Natural := 1000)
     with Pre => Is_Configured (Port);

private

   type I2C_State is
     (Reset,
      Ready,
      Master_Busy_Tx,
      Master_Busy_Rx,
      Mem_Busy_Tx,
      Mem_Busy_Rx);

   type I2C_Port is new HAL.I2C.I2C_Controller with record
      Periph : access STM32_SVD.I2C.I2C_Peripheral;
      Config : I2C_Configuration;
      State  : I2C_State := Reset;
   end record;

end STM32.I2C;
