-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                      Copyright (C) 2006                           --
--                             AdaCore                               --
--                                                                   --
-- GPS is free  software;  you can redistribute it and/or modify  it --
-- under the terms of the GNU General Public License as published by --
-- the Free Software Foundation; either version 2 of the License, or --
-- (at your option) any later version.                               --
--                                                                   --
-- This program is  distributed in the hope that it will be  useful, --
-- but  WITHOUT ANY WARRANTY;  without even the  implied warranty of --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details. You should have received --
-- a copy of the GNU General Public License along with this library; --
-- if not,  write to the  Free Software Foundation, Inc.,  59 Temple --
-- Place - Suite 330, Boston, MA 02111-1307, USA.                    --
-----------------------------------------------------------------------

with Ada.Unchecked_Deallocation;

package body Lazy_Vectors is

   ----------
   -- Free --
   ----------

   procedure Free (This : in out Lazy_Vector) is
      procedure Internal is new Ada.Unchecked_Deallocation
        (Lazy_Vector_Record, Lazy_Vector);
   begin
      Free (This.Datas);
      Internal (This);
   end Free;

   ------------
   -- Insert --
   ------------

   procedure Insert  (Vector : access Lazy_Vector_Record; Data : Data_Type) is
      Dummy : Iterator;
   begin
      Insert (Vector, Data, Dummy);
   end Insert;

   ------------
   -- Insert --
   ------------

   procedure Insert
     (Vector : access Lazy_Vector_Record;
      Data   : Data_Type;
      Pos    : out Iterator)
   is
   begin
      Pos.Vector := Vector;

      if Vector.Datas = null then
         Vector.Datas := new Data_Array'(1 => Data);
         Pos.Index := 1;
         return;
      end if;

      for J in Vector.Datas'Range loop
         if Vector.Datas (J) = Null_Data_Type then
            Vector.Datas (J) := Data;
            Pos.Index := J;
            return;
         end if;
      end loop;

      declare
         Old_Array : Data_Array_Access := Vector.Datas;
      begin
         Vector.Datas := new Data_Array (1 .. Vector.Datas'Length * 2);
         Vector.Datas (1 .. Old_Array.all'Last) := Old_Array.all;
         Vector.Datas (Old_Array'Last + 1) := Data;
         Pos.Index := Old_Array'Last + 1;
         Vector.Datas (Old_Array'Last + 2 .. Vector.Datas'Last) :=
           (others => Null_Data_Type);
         Free (Old_Array);
      end;
   end Insert;

   -----------
   -- First --
   -----------

   function First (Vector : Lazy_Vector) return Iterator is
      It : Iterator;
   begin
      It.Vector := Vector;
      It.Index := 1;

      if not Is_Valid (It) then
         Next (It);
      end if;

      return It;
   end First;

   ----------
   -- Next --
   ----------

   procedure Next (It : in out Iterator) is
   begin
      It.Index := It.Index + 1;

      if not Is_Valid (It) then
         Next (It);
      end if;
   end Next;

   ------------
   -- At_End --
   ------------

   function At_End (It : Iterator) return Boolean is
   begin
      return It.Vector = null or else It.Index > It.Vector.Datas'Last;
   end At_End;

   ---------
   -- Get --
   ---------

   function Get (It : Iterator) return Data_Type is
   begin
      return It.Vector.Datas (It.Index);
   end Get;

   ------------
   -- Delete --
   ------------

   procedure Delete (It : Iterator) is
   begin
      It.Vector.Datas (It.Index) := Null_Data_Type;
   end Delete;

   --------------
   -- Is_Valid --
   --------------

   function Is_Valid (It : Iterator) return Boolean is
   begin
      return At_End (It) or else It.Vector.Datas (It.Index) /= Null_Data_Type;
   end Is_Valid;

   ----------
   -- Free --
   ----------

   procedure Free (This : in out Data_Array_Access) is
      procedure Internal_Free is new Ada.Unchecked_Deallocation
        (Data_Array, Data_Array_Access);
   begin
      Internal_Free (This);
   end Free;

end Lazy_Vectors;
