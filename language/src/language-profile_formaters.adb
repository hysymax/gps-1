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

with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Language.Profile_Formaters is

   -------------------
   -- Add_Parameter --
   -------------------

   overriding procedure Add_Parameter
     (Self    : access Text_Profile_Formater;
      Name    : String;
      Mode    : String;
      Of_Type : String;
      Default : String)
   is
      use Ada.Strings.Unbounded;

      Mode_Image : constant String := Trim (Mode, Ada.Strings.Right);
   begin
      if not Self.Has_Parameter then
         Append (Self.Text, "(");
         Self.Has_Parameter := True;
      else
         Append (Self.Text, ";");
      end if;

      Append (Self.Text, Trim (Name, Ada.Strings.Right));
      Append (Self.Text, " : ");

      if Mode_Image /= "" then
         Append (Self.Text, Mode_Image);
         Append (Self.Text, " ");
      end if;

      Append (Self.Text, Trim (Of_Type, Ada.Strings.Right));

      if Default /= "" then
         Append (Self.Text, " :=");
         Append (Self.Text, Default);
      end if;
   end Add_Parameter;

   ----------------
   -- Add_Result --
   ----------------

   overriding procedure Add_Result
     (Self    : access Text_Profile_Formater;
      Mode    : String;
      Of_Type : String)
   is
      use Ada.Strings.Unbounded;
   begin
      if Self.Has_Parameter then
         Append (Self.Text, ")");
         Self.Has_Parameter := False;
      end if;
      Append (Self.Text, " return ");
      Append (Self.Text, Trim (Mode, Ada.Strings.Right));
      Append (Self.Text, " ");
      Append (Self.Text, Of_Type);
   end Add_Result;

   ------------------
   -- Add_Variable --
   ------------------

   overriding procedure Add_Variable
     (Self    : access Text_Profile_Formater;
      Mode    : String;
      Of_Type : String)
   is
      use Ada.Strings.Unbounded;
   begin
      Append (Self.Text, " ");
      Append (Self.Text, Trim (Mode, Ada.Strings.Right));
      Append (Self.Text, " ");
      Append (Self.Text, Of_Type);
   end Add_Variable;

   -----------------
   -- Add_Aspects --
   -----------------

   overriding procedure Add_Aspects
     (Self : access Text_Profile_Formater;
      Text : String) is
   begin
      --  No aspects in text format for now
      null;
   end Add_Aspects;

   ------------------
   -- Add_Comments --
   ------------------

   overriding procedure Add_Comments
     (Self : access Text_Profile_Formater;
      Text : String)
   is
      use Ada.Strings.Unbounded;
   begin
      if Self.Has_Parameter then
         Append (Self.Text, ")");
         Self.Has_Parameter := False;
      end if;
      Append (Self.Text, ASCII.LF);
      Append (Self.Text, Text);
   end Add_Comments;

   --------------
   -- Get_Text --
   --------------

   overriding function Get_Text
     (Self : access Text_Profile_Formater) return String
   is
      use Ada.Strings.Unbounded;
   begin
      if Self.Has_Parameter then
         Append (Self.Text, ")");
         Self.Has_Parameter := False;
      end if;

      return To_String (Self.Text);
   end Get_Text;

end Language.Profile_Formaters;