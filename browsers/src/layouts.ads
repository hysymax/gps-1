-----------------------------------------------------------------------
--                              G P S                                --
--                                                                   --
--                     Copyright (C) 2001-2005                       --
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

with Glib.Graphs;
with Gtkada.Canvas;

package Layouts is

   procedure Layer_Layout
     (Canvas : access Gtkada.Canvas.Interactive_Canvas_Record'Class;
      Graph  : Glib.Graphs.Graph;
      Force  : Boolean := False;
      Vertical_Layout : Boolean := True);
   --  Layout the graph in layers

   procedure Simple_Layout
     (Canvas : access Gtkada.Canvas.Interactive_Canvas_Record'Class;
      Graph  : Glib.Graphs.Graph;
      Force  : Boolean := False;
      Vertical_Layout : Boolean := True);
   --  Simple layout, where items are put in the first possible column

end Layouts;
