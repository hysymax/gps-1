-----------------------------------------------------------------------
--                   GVD - The GNU Visual Debugger                   --
--                                                                   --
--                      Copyright (C) 2000-2002                      --
--                              ACT-Europe                           --
--                                                                   --
-- GVD is free  software;  you can redistribute it and/or modify  it --
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

with Glib.Object;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Box; use Gtk.Box;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Clist; use Gtk.Clist;
with Gtk.Handlers;
with Gtk.Hbutton_Box; use Gtk.Hbutton_Box;
with Gtk.Button; use Gtk.Button;
with Gtk.List; use Gtk.List;
with Gtk.Window; use Gtk.Window;
with Gtk.Enums;
with Debugger; use Debugger;
with Basic_Types;
with Histories;

package GVD.Dialogs is

   type GVD_Dialog_Record is new Gtk_Dialog_Record with private;
   type GVD_Dialog is access all GVD_Dialog_Record'Class;

   type Task_Dialog_Record is new GVD_Dialog_Record with private;
   type Task_Dialog_Access is access all Task_Dialog_Record'Class;

   type Thread_Dialog_Record is new GVD_Dialog_Record with private;
   type Thread_Dialog_Access is access all Thread_Dialog_Record'Class;

   type PD_Dialog_Record is new GVD_Dialog_Record with private;
   type PD_Dialog_Access is access all PD_Dialog_Record'Class;

   type Question_Dialog_Record is new GVD_Dialog_Record with private;
   type Question_Dialog_Access is access all Question_Dialog_Record'Class;

   type History_Dialog_Record is new Gtk_Dialog_Record with private;
   type History_Dialog_Access is access all History_Dialog_Record'Class;

   type Question_Record is record
      Choice : Basic_Types.String_Access;
      --  String that the user should enter to select that choice

      Description : Basic_Types.String_Access;
      --  Associated description
   end record;
   type Question_Array is array (Positive range <>) of Question_Record;

   procedure Free (Questions : in out Question_Array);
   --  Free all the dynamic memory associated with each question record.

   procedure Gtk_New
     (Task_Dialog : out Task_Dialog_Access;
      Main_Window : Gtk_Window);
   --  Create an empty task dialog.
   --  No information will be displayed in it, and you need to add it through
   --  a call to Update.

   procedure Initialize
     (Task_Dialog : access Task_Dialog_Record'Class;
      Main_Window : Gtk_Window);
   --  Internal initialization function

   procedure Update
     (Task_Dialog : access Task_Dialog_Record;
      Debugger    : access Glib.Object.GObject_Record'Class);
   --  Update the contents of the task dialog.
   --  The information is read from Debugger (which is in fact a
   --  Visual_Debugger).

   procedure On_Task_Process_Stopped
     (Widget : access Glib.Object.GObject_Record'Class);
   --  Callback function connected to the "process_stopped" signal.
   --  It will update the task window associated with a given tab.

   procedure Gtk_New
     (Thread_Dialog : out Thread_Dialog_Access;
      Main_Window   : Gtk_Window);
   --  Create an empty thread dialog.
   --  No information will be displayed in it, and you need to add it through
   --  a call to Update.

   procedure Initialize
     (Thread_Dialog : access Thread_Dialog_Record'Class;
      Main_Window   : Gtk_Window);
   --  Internal initialization function

   procedure Update
     (Thread_Dialog : access Thread_Dialog_Record;
      Debugger      : access Glib.Object.GObject_Record'Class);
   --  Update the contents of the thread dialog.
   --  The information is read from Debugger (which is in fact a
   --  Visual_Debugger).

   procedure On_Thread_Process_Stopped
     (Widget : access Glib.Object.GObject_Record'Class);
   --  Callback function connected to the "process_stopped" signal.
   --  It will update the thread window associated with a given tab.

   procedure Gtk_New
     (PD_Dialog  : out PD_Dialog_Access;
      Main_Window : Gtk_Window);
   --  Create an empty protection domains dialog.
   --  No information will be displayed in it, and you need to add it through
   --  a call to Update.

   procedure Initialize
     (PD_Dialog  : access PD_Dialog_Record'Class;
      Main_Window : Gtk_Window);
   --  Internal initialization function

   procedure Update
     (PD_Dialog  : access PD_Dialog_Record;
      Debugger   : access Glib.Object.GObject_Record'Class);
   --  Update the contents of the protection domains dialog.
   --  The information is read from Debugger (which is in fact a
   --  Visual_Debugger).

   procedure On_PD_Process_Stopped
     (Widget : access Glib.Object.GObject_Record'Class);
   --  Callback function connected to the "process_stopped" signal.
   --  It will update the protection domains window associated with a given
   --  tab.

   procedure Update_Call_Stack
     (Debugger : access Glib.Object.GObject_Record'Class);
   --  Update the contents of the call stack window.
   --  The information is read from Debugger (which is in fact a
   --  Visual_Debugger).

   procedure Show_Call_Stack_Columns
     (Debugger : access Glib.Object.GObject_Record'Class);
   --  Show or hide the relevant column in the call stack list for a
   --  specific debugger, based on the settings in Debugger.Backtrace_Filter

   procedure On_Stack_Process_Stopped
     (Widget : access Glib.Object.GObject_Record'Class);
   --  Callback function connected to the "process_stopped" signal.
   --  It will update the call stack window associated with a given tab.

   procedure Highlight_Stack_Frame
     (Debugger : access Glib.Object.GObject_Record'Class;
      Frame    : Natural);
   --  Highlights a specific frame in the call stack list for a specific
   --  debugger.
   --  Frame 1 is the first one visible in the list.

   procedure Gtk_New
     (Question_Dialog            : out Question_Dialog_Access;
      Main_Window                : Gtk_Window;
      Debugger                   : Debugger_Access;
      Multiple_Selection_Allowed : Boolean;
      Questions                  : Question_Array;
      Question_Description       : String := "");
   --  Create a question dialog with a list of questions.
   --  If Questions consists of two choices "y" and "n" then display
   --  only a basic Yes/No dialog.

   procedure Initialize
     (Question_Dialog            : access Question_Dialog_Record'Class;
      Main_Window                : Gtk_Window;
      Debugger                   : Debugger_Access;
      Multiple_Selection_Allowed : Boolean;
      Questions                  : Question_Array;
      Question_Description       : String := "");

   procedure Gtk_New
     (History_Dialog : out History_Dialog_Access;
      Main_Window    : Gtk_Window);
   --  Create a new history dialog.
   --  Main_Window should be the main debug window. The information will be
   --  blank, so you should call Update to add data.

   procedure Initialize
     (History_Dialog : access History_Dialog_Record'Class);
   --  Internal inititialization function.

   procedure Update
     (History_Dialog : History_Dialog_Access;
      Debugger       : access Glib.Object.GObject_Record'Class);
   --  Reads the commands history from the main debug window, and fills the
   --  list with the User and Visible commands that were sent to Debugger.

   function Simple_Entry_Dialog
     (Parent    : access Gtk.Window.Gtk_Window_Record'Class;
      Title     : String;
      Message   : String;
      Position  : Gtk.Enums.Gtk_Window_Position := Gtk.Enums.Win_Pos_Mouse;
      History   : Histories.History := null;
      Key       : Histories.History_Key := "") return String;
   --  Open a simple dialog, with a single entry field, and returns the
   --  contents of this field (or ASCII.NUL) if the user selected cancel).
   --  The dialog is set up as a child of Parent, so that, depending on the
   --  window manager, it isn't displayed below it.
   --  if Key is not the empty string, then the combobox's content is
   --  initialized from the corresponding entry in History.
   --  Position indicates where the dialog should be positionned.

   type Boolean_Access is access all Boolean;

   function Display_Entry_Dialog
     (Parent         : access Gtk.Window.Gtk_Window_Record'Class;
      Title          : String;
      Message        : String;
      Position       : Gtk.Enums.Gtk_Window_Position :=
        Gtk.Enums.Win_Pos_Mouse;
      Check_Msg      : String;
      History        : Histories.History;
      Key            : Histories.History_Key := "";

      Button_Active  : access Boolean;
      Key_Check      : Histories.History_Key;

      Check_Msg2     : String := "";
      Button2_Active : Boolean_Access := null;
      Key_Check2     : Histories.History_Key := "") return String;
   --  A dialog, like Simple_Entry_Dialog, specifically set up to enter
   --  expressions to display.

   procedure Freeze (Dialog : History_Dialog_Access);
   procedure Thaw (Dialog : History_Dialog_Access);
   --  These procedures are used to lock the list of commands.

private
   type GVD_Dialog_Record is new Gtk_Dialog_Record with record
      Main_Window     : Gtk_Window;
      Vbox1           : Gtk_Vbox;
      Scrolledwindow1 : Gtk_Scrolled_Window;
      List            : Gtk_Clist;
      Hbox1           : Gtk_Hbox;
      Hbuttonbox1     : Gtk_Hbutton_Box;
      Close_Button    : Gtk_Button;
      Select_Row_Id   : Gtk.Handlers.Handler_Id;
   end record;
   --  ??? Why not store directly the Visual_Debugger in this record,
   --  instead of having to convert in the callbacks ?

   type Task_Dialog_Record is new GVD_Dialog_Record with null record;

   type Thread_Dialog_Record is new GVD_Dialog_Record with null record;

   type PD_Dialog_Record is new GVD_Dialog_Record with null record;

   type Question_Dialog_Record is new GVD_Dialog_Record with record
      Debugger : Debugger_Access;
   end record;
   --  We have to store the debugger for this dialog, since the user's choice
   --  should be sent to the right debugger, even if the user has switched
   --  tabs in between.

   type History_Dialog_Record is new Gtk_Dialog_Record with record
      Vbox1            : Gtk_Vbox;
      Scrolledwindow1  : Gtk_Scrolled_Window;
      List             : Gtk_List;
      Hbuttonbox1      : Gtk_Hbutton_Box;
      Replay_Selection : Gtk_Button;
      Cancel           : Gtk_Button;
      Help             : Gtk_Button;

      Window           : Gtk_Window;
      --  This is in fact the main debug window.

      Freeze_Count     : Integer := 0;
      --  Used to lock the History_Dialog while replaying commands.
   end record;

   procedure Update_PD
     (Dialog   : access GVD_Dialog_Record'Class;
      Info     : in out PD_Information_Array);

end GVD.Dialogs;
