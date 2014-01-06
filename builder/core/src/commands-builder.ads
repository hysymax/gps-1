------------------------------------------------------------------------------
--                                  G P S                                   --
--                                                                          --
--                     Copyright (C) 2003-2014, AdaCore                     --
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

--  This package handles build commands

with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with GNAT.OS_Lib;               use GNAT.OS_Lib;

with GNATCOLL.VFS;              use GNATCOLL.VFS;
with Remote;                    use Remote;
with Build_Command_Utils;       use Build_Command_Utils;

package Commands.Builder is

   Error_Category : constant String := "Builder results";
   --  -"Builder results"

   procedure Launch_Target
     (Builder     : Builder_Context;
      Target_Name : String;
      Mode_Name   : String;
      Force_File  : Virtual_File;
      Extra_Args  : Argument_List_Access;
      Quiet       : Boolean;
      Synchronous : Boolean;
      Dialog      : Dialog_Mode;
      Main        : Virtual_File;
      Background  : Boolean;
      Directory   : Virtual_File := No_File);
   --  Launch a build of target named Target_Name
   --  If Mode_Name is not the empty string, then the mode Mode_Name will be
   --  used.
   --  If Force_File is not set to No_File, then force the command to work
   --  on this file. (This is needed to support GPS scripting).
   --  Extra_Args may point to a list of unexpanded args.
   --  If Quiet is true:
   --    - files are not saved before build launch
   --    - the console is not raised when launching the build
   --    - the console is not cleared when launching the build
   --  If Synchronous is True, GPS will block until the command is terminated.
   --  See document of Dialog_Mode for details on Dialog values.
   --  Main, if not empty, indicates the main to build.
   --  If Directory is not empty, indicates which directory the target should
   --  be run under. Default is the project's directory.
   --  If Background, run the compile in the background.

   procedure Launch_Build_Command
     (Builder          : Builder_Context;
      Build            : Build_Information;
      Server           : Server_Type;
      Synchronous      : Boolean);
   --  Launch a build command using build information stored in Build.
   --  Use given Console to send the output.
   --  See Build_Command_Manager.Launch_Target for the meanings of Synchronous.

end Commands.Builder;
