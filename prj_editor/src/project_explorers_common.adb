-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                     Copyright (C) 2001-2002                       --
--                            ACT-Europe                             --
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
-- a copy of the GNU General Public License along with this program; --
-- if not,  write to the  Free Software Foundation, Inc.,  59 Temple --
-- Place - Suite 330, Boston, MA 02111-1307, USA.                    --
-----------------------------------------------------------------------

with Basic_Types;               use Basic_Types;
with Pixmaps_IDE;               use Pixmaps_IDE;
with Pixmaps_Prj;               use Pixmaps_Prj;
with Gdk.Pixbuf;                use Gdk.Pixbuf;
with Language.Unknown;          use Language.Unknown;
with Language;                  use Language;
with Language_Handlers.Glide;   use Language_Handlers.Glide;
with GNAT.Directory_Operations; use GNAT.Directory_Operations;
with Glide_Kernel.Project;      use Glide_Kernel.Project;
with Glide_Kernel.Modules;      use Glide_Kernel.Modules;
with String_Utils;              use String_Utils;
with Src_Info;
with Gtk.Tree_View_Column;      use Gtk.Tree_View_Column;
with Gtk.Tree_Selection; use Gtk.Tree_Selection;

package body Project_Explorers_Common is

   -------------------
   -- Columns_Types --
   -------------------

   function Columns_Types return GType_Array is
   begin
      return GType_Array'
        (Icon_Column          => Gdk.Pixbuf.Get_Type,
         Absolute_Name_Column => GType_String,
         Base_Name_Column     => GType_String,
         Node_Type_Column     => GType_Int,
         User_Data_Column     => GType_Pointer,
         Line_Column          => GType_Int,
         Column_Column        => GType_Int,
         Project_Column       => GType_Int,
         Category_Column      => GType_Int,
         Up_To_Date_Column    => GType_Boolean);
   end Columns_Types;

   -------------------
   -- Init_Graphics --
   -------------------

   procedure Init_Graphics is
   begin
      --  If initialization has already been done, exit.
      if Open_Pixbufs (Project_Node) /= null then
         return;
      end if;

      Open_Pixbufs (Project_Node)  :=
        Gdk_New_From_Xpm_Data (project_xpm);
      Close_Pixbufs (Project_Node) :=
        Gdk_New_From_Xpm_Data (project_closed_xpm);
      Open_Pixbufs (Modified_Project_Node)  :=
        Gdk_New_From_Xpm_Data (project_modified_xpm);
      Close_Pixbufs (Modified_Project_Node) :=
        Gdk_New_From_Xpm_Data (project_modified_closed_xpm);
      Open_Pixbufs (Extends_Project_Node)  :=
        Gdk_New_From_Xpm_Data (project_ext_xpm);
      Close_Pixbufs (Extends_Project_Node) :=
        Gdk_New_From_Xpm_Data (project_ext_closed_xpm);
      Open_Pixbufs (Directory_Node)  :=
        Gdk_New_From_Xpm_Data (mini_ofolder_xpm);
      Close_Pixbufs (Directory_Node) :=
        Gdk_New_From_Xpm_Data (mini_folder_xpm);
      Open_Pixbufs (Obj_Directory_Node)  :=
        Gdk_New_From_Xpm_Data (mini_folder_object_xpm);
      Close_Pixbufs (Obj_Directory_Node) :=
        Gdk_New_From_Xpm_Data (mini_folder_object_xpm);
      Open_Pixbufs (File_Node)  :=
        Gdk_New_From_Xpm_Data (mini_page_xpm);
      Close_Pixbufs (File_Node) :=
        Gdk_New_From_Xpm_Data (mini_page_xpm);
      Open_Pixbufs (Category_Node)  :=
        Gdk_New_From_Xpm_Data (var_xpm);
      Close_Pixbufs (Category_Node) :=
        Gdk_New_From_Xpm_Data (var_xpm);

   end Init_Graphics;

   -----------------
   -- Append_File --
   -----------------

   procedure Append_File
     (Kernel : Kernel_Handle;
      Model  : Gtk_Tree_Store;
      Base   : Gtk_Tree_Iter;
      File   : String)
   is
      Iter : Gtk_Tree_Iter;
      Lang : Language_Access;
   begin
      Append (Model, Iter, Base);

      Set (Model, Iter, Absolute_Name_Column, File);

      Set (Model, Iter, Base_Name_Column, Base_Name (File));

      Set (Model, Iter, Icon_Column,
           C_Proxy (Close_Pixbufs (File_Node)));
      Set (Model, Iter, Node_Type_Column,
           Gint (Node_Types'Pos (File_Node)));
      Set (Model, Iter, Up_To_Date_Column, False);

      Lang := Get_Language_From_File
        (Glide_Language_Handler (Get_Language_Handler (Kernel)),
         File);

      if Lang /= Unknown_Lang then
         Append_Dummy_Iter (Model, Iter);
      end if;
   end Append_File;

   -----------------------
   -- Append_Dummy_Iter --
   -----------------------

   procedure Append_Dummy_Iter
     (Model : Gtk_Tree_Store;
      Base  : Gtk_Tree_Iter)
   is
      Iter : Gtk_Tree_Iter;
   begin
      Append (Model, Iter, Base);
   end Append_Dummy_Iter;

   --------------------------
   -- Append_Category_Node --
   --------------------------

   function Append_Category_Node
     (Model       : Gtk_Tree_Store;
      Category    : Language_Category;
      Parent_Iter : Gtk_Tree_Iter) return Gtk_Tree_Iter
   is
      N       : Gtk_Tree_Iter;
      Sibling : Gtk_Tree_Iter;
      Name    : constant String := Category_Name (Category);
   begin
      Sibling := Children (Model, Parent_Iter);

      if Sibling = Null_Iter then
         Append (Model, N, Parent_Iter);
      else
         while Sibling /= Null_Iter
           and then Get_String (Model, Sibling, Base_Name_Column)
           <= Name
         loop
            Next (Model, Sibling);
         end loop;

         if Sibling = Null_Iter then
            Append (Model, N, Parent_Iter);
         else
            Insert_Before (Model, N, Parent_Iter, Sibling);
         end if;
      end if;

      Set (Model, N, Absolute_Name_Column, "");
      Set (Model, N, Base_Name_Column, Name);
      Set (Model, N, Icon_Column,
           C_Proxy (Close_Pixbufs (Category_Node)));
      Set (Model, N, Node_Type_Column,
           Gint (Node_Types'Pos (Category_Node)));
      Set (Model, N, Up_To_Date_Column, True);
      Set (Model, N, Category_Column, Language_Category'Pos (Category));

      return N;
   end Append_Category_Node;

   ------------------------
   -- Append_Entity_Node --
   ------------------------

   function Append_Entity_Node
     (Model       : Gtk_Tree_Store;
      File        : String;
      Construct   : Construct_Information;
      Parent_Iter : Gtk_Tree_Iter) return Gtk_Tree_Iter
   is
      N       : Gtk_Tree_Iter;
      Sibling : Gtk_Tree_Iter;
   begin
      Sibling := Children (Model, Parent_Iter);

      if Sibling = Null_Iter then
         Append (Model, N, Parent_Iter);
      else
         while Sibling /= Null_Iter
           and then Get_String (Model, Sibling, Base_Name_Column)
           <= Construct.Name.all
         loop
            Next (Model, Sibling);
         end loop;

         if Sibling = Null_Iter then
            Append (Model, N, Parent_Iter);
         else
            Insert_Before (Model, N, Parent_Iter, Sibling);
         end if;
      end if;

      Set (Model, N, Absolute_Name_Column, File);

      if Construct.Is_Declaration then
         if Construct.Profile /= null then
            Set (Model, N, Base_Name_Column,
                 Construct.Name.all & " (spec) " &
                 Reduce (Construct.Profile.all));
         else
            Set (Model, N, Base_Name_Column,
                 Construct.Name.all & " (spec)");

         end if;

      elsif Construct.Profile /= null then
         Set (Model, N, Base_Name_Column,
              Construct.Name.all & " " & Reduce (Construct.Profile.all));
      else
         Set (Model, N, Base_Name_Column,
              Construct.Name.all);
      end if;

      Set (Model, N, Icon_Column,
           C_Proxy (Close_Pixbufs (Entity_Node)));
      Set (Model, N, Node_Type_Column,
           Gint (Node_Types'Pos (Entity_Node)));

      Set (Model, N,
           Line_Column, Gint (Construct.Sloc_Entity.Line));
      Set (Model, N,
           Column_Column, Gint (Construct.Sloc_Entity.Column));
      Set (Model, N, Up_To_Date_Column, True);
      return N;
   end Append_Entity_Node;

   ----------------------
   -- Append_File_Info --
   ----------------------

   procedure Append_File_Info
     (Kernel    : Kernel_Handle;
      Model     : Gtk_Tree_Store;
      Node      : Gtk_Tree_Iter;
      File_Name : String)
   is
      use Src_Info;

      N          : Gtk_Tree_Iter;
      pragma Unreferenced (N);

      Lang       : Language_Access;
      Constructs : Construct_List;
      Category   : Language_Category;

      type Gtk_Tree_Iter_Array is array (Language_Category'Range)
        of Gtk_Tree_Iter;
      Categories : Gtk_Tree_Iter_Array := (others => Null_Iter);
      Languages  : constant Glide_Language_Handler :=
        Glide_Language_Handler (Get_Language_Handler (Kernel));
      Handler    : constant Src_Info.LI_Handler :=
        Get_LI_Handler_From_File (Languages, File_Name);
   begin
      Push_State (Kernel, Busy);

      Lang := Get_Language_From_File
        (Glide_Language_Handler (Get_Language_Handler (Kernel)),
         File_Name);

      if Lang /= null then
         Parse_File_Constructs
           (Handler, Get_Project_View (Kernel),
            Languages, File_Name, Constructs);

         Constructs.Current := Constructs.First;

         while Constructs.Current /= null loop
            if Constructs.Current.Name /= null then
               Category := Filter_Category (Constructs.Current.Category);

               if Category /= Cat_Unknown then
                  if Categories (Category) = Null_Iter then
                     Categories (Category) := Append_Category_Node
                       (Model,
                        Category    => Category,
                        Parent_Iter => Node);
                  end if;

                  N := Append_Entity_Node
                    (Model, File_Name,
                     Constructs.Current.all, Categories (Category));
               end if;
            end if;

            Constructs.Current := Constructs.Current.Next;
         end loop;

         Free (Constructs);
      end if;

      Pop_State (Kernel);
   end Append_File_Info;

   ---------------------
   -- Filter_Category --
   ---------------------

   function Filter_Category
     (Category : Language_Category) return Language_Category is
   begin
      --  No "with", "use", "#include"
      --  No constructs ("loop", "if", ...)

      if Category in Dependency_Category
        or else Category in Construct_Category
        or else Category = Cat_Representation_Clause
        or else Category = Cat_Local_Variable
      then
         return Cat_Unknown;

         --  All subprograms are grouped together

      elsif Category in Subprogram_Explorer_Category then
         return Cat_Procedure;

      elsif Category in Type_Category then
         return Cat_Type;

      end if;

      return Category;
   end Filter_Category;

   -------------------------
   -- Find_Iter_For_Event --
   -------------------------

   function Find_Iter_For_Event
     (Tree  : access Gtk_Tree_View_Record'Class;
      Model : Gtk_Tree_Store;
      Event : Gdk_Event) return Gtk_Tree_Iter
   is
      X         : Gdouble;
      Y         : Gdouble;
      Buffer_X  : Gint;
      Buffer_Y  : Gint;
      Row_Found : Boolean;
      Path      : Gtk_Tree_Path;
      Column    : Gtk_Tree_View_Column := null;
      Iter      : Gtk_Tree_Iter := Null_Iter;
      N_Model   : Gtk_Tree_Model;
   begin
      if Event /= null then
         X := Get_X (Event);
         Y := Get_Y (Event);
         Path := Gtk_New;
         Get_Path_At_Pos
           (Tree,
            Gint (X),
            Gint (Y),
            Path,
            Column,
            Buffer_X,
            Buffer_Y,
            Row_Found);

         if Path = null then
            return Iter;
         end if;

         Select_Path (Get_Selection (Tree), Path);
         Iter := Get_Iter (Model, Path);
         Path_Free (Path);
      else
         Get_Selected (Get_Selection (Tree),
                       N_Model,
                       Iter);
      end if;

      return Iter;
   end Find_Iter_For_Event;

   ---------------------
   -- On_Button_Press --
   ---------------------

   function On_Button_Press
     (Kernel    : Kernel_Handle;
      Tree      : access Gtk_Tree_View_Record'Class;
      Model     : Gtk_Tree_Store;
      Event     : Gdk_Event;
      Add_Dummy : Boolean) return Boolean
   is
      Iter         : Gtk_Tree_Iter;
      Line, Column : Gint;
   begin
      if Get_Button (Event) = 1 then
         Iter := Find_Iter_For_Event (Tree, Model, Event);

         if Iter /= Null_Iter then
            case Node_Types'Val
                 (Integer (Get_Int (Model, Iter, Node_Type_Column))) is

               when Directory_Node | Project_Node =>
                  if Get_Event_Type (Event) = Gdk_2button_Press then
                     declare
                        Path    : Gtk_Tree_Path;
                        Success : Boolean;
                        pragma Unreferenced (Success);
                     begin
                        Path := Get_Path (Model, Iter);

                        if Row_Expanded (Tree, Path) then
                           Success := Collapse_Row (Tree, Path);
                        else
                           if Add_Dummy then
                              Append_Dummy_Iter (Model, Iter);
                           end if;

                           Success := Expand_Row
                             (Tree, Path, False);
                        end if;

                        Path_Free (Path);
                     end;
                  end if;

                  return False;

               when File_Node =>
                  if (Get_Event_Type (Event) = Gdk_2button_Press
                      or else Get_Event_Type (Event) = Gdk_3button_Press)
                  then
                     Open_File_Editor
                       (Kernel,
                        Get_String (Model, Iter, Absolute_Name_Column));
                     return True;
                  end if;

               when Entity_Node =>
                  Line := Get_Int (Model, Iter, Line_Column);
                  Column := Get_Int (Model, Iter, Column_Column);

                  Open_File_Editor
                    (Kernel,
                     Get_String (Model, Iter, Absolute_Name_Column),
                     Line   => Natural (Line),
                     Column => Natural (Column));
                  return False;

               when others =>
                  return False;
            end case;

         end if;
      end if;

      return False;
   end On_Button_Press;

   -------------------
   -- Get_Node_Type --
   -------------------

   function Get_Node_Type
     (Model : Gtk_Tree_Store;
      Node  : Gtk_Tree_Iter) return Node_Types is
   begin
      return
        Node_Types'Val
          (Integer
               (Get_Int (Model, Node, Node_Type_Column)));
   end Get_Node_Type;

   -----------------------
   -- Get_Category_Type --
   -----------------------

   function Get_Category_Type
     (Model : Gtk_Tree_Store;
      Node  : Gtk_Tree_Iter) return Language_Category is
   begin
      return
        Language_Category'Val
          (Integer
               (Get_Int (Model, Node, Category_Column)));
   end Get_Category_Type;

   -------------------
   -- Is_Up_To_Date --
   -------------------

   function Is_Up_To_Date
     (Model : Gtk_Tree_Store;
      Node  : Gtk_Tree_Iter) return Boolean is
   begin
      return
        Get_Boolean (Model, Node, Up_To_Date_Column);
   end Is_Up_To_Date;

   --------------------
   -- Set_Up_To_Date --
   --------------------

   procedure Set_Up_To_Date
     (Model : Gtk_Tree_Store;
      Node  : Gtk_Tree_Iter;
      State : Boolean) is
   begin
      Set (Model, Node, Up_To_Date_Column, State);
   end Set_Up_To_Date;

   -------------------
   -- Get_Base_Name --
   -------------------

   function Get_Base_Name
     (Model : Gtk_Tree_Store;
      Node  : Gtk_Tree_Iter) return String is
   begin
      return Get_String (Model, Node, Base_Name_Column);
   end Get_Base_Name;

end Project_Explorers_Common;
