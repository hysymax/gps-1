------------------------------------------------------------------------------
--                                  G P S                                   --
--                                                                          --
--                        Copyright (C) 2013, AdaCore                       --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

--  This package defines the abstract root type for message console.

package GPS.Messages_Windows is

   ---------------------
   -- Messages window --
   ---------------------

   type Message_Type is (Info, Error, Verbose);
   --  We are dealing with 3 types of messages :
   --   - Info for general information
   --   - Error for signaling errors
   --   - Verbose for detailed information

   type Abstract_Messages_Window is abstract tagged null record;
   type Abstract_Messages_Window_Access is
     access all Abstract_Messages_Window'Class;
   procedure Insert
     (Self   : not null access Abstract_Messages_Window;
      Text   : String;
      Add_LF : Boolean := True;
      Mode   : Message_Type := Info) is abstract;
   --  Insert Text in the GPS's console.
   --  If Add_LF is True, automatically add a line separator.

end GPS.Messages_Windows;