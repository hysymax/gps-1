--  Persistent pool of names for xref files.
--  Generates unique filename for given source file name.

with HTables;

package SN.Xref_Pools is

   type Xref_Pool is private;
   Empty_Xref_Pool : constant Xref_Pool;

   Xref_File_Error : exception;
   --  Exception raised if xref file cannot be created, read, written.

   Xref_Suffix : constant String := ".xref";
   --  This suffix is used for generating xref file names.
   --  In fact generated names are constructed in this way:
   --  F(Source_Filename) & Xref_Suffix, where F is a functions that
   --  generates some unique name from source file name.
   --  Thus, "*." & Xref_Suffix is a mask to search all xref files.

   procedure Init (Pool : out Xref_Pool);
   --  Creates new empty pool.

   procedure Load (Pool : in out Xref_Pool; Filename : String);
   --  Loads pool from specified file. Does the same as Init if specified
   --  file does not exist.

   procedure Save (Pool : Xref_Pool; Filename : String);
   --  Saves pool to specified file. Overwrite existing file.
   --  Raises Xref_File_Error if writing failed.

   procedure Free (Pool : in out Xref_Pool);
   --  Releases pool's resources from memory. Does nothing to
   --  persistent storage.

   function Xref_Filename_For
     (Source_Filename : String;
      Directory       : String;
      Pool            : Xref_Pool) return String_Access;
   --  Returns unique xref file name associated with specified source file
   --  name. It does the following steps:
   --
   --  1. Generates some xref file name based on specified source file name.
   --  2. Checks if file with that name already exists in specified
   --  directory. If not, generated name is stored in hashtabe using
   --  source file name as the key. Also it creates that file in specified
   --  directory and returns its name.
   --  3. If generated file already exists, it makes modification to
   --  generated (to achieve uniquity) and jumps to step 2.
   --
   --  Raises Xref_File_Error if it could not create file with generated
   --  file name in specified directory.

   procedure Free_Filename_For
     (Source_Filename : String;
      Directory       : String;
      Pool            : Xref_Pool);
   --  Releases previously generated xref file name from memory,
   --  removes it from disk (in specified directory),
   --  thus makes that name able to associate with other source file name.

   function Is_Xref_Valid
     (Source_Filename : String;
      Pool            : Xref_Pool) return Boolean;
   --  Return valig flag for xref file associated with given source file name.
   --  Returns False if no xref file for given file was generated yet.

   procedure Set_Valid
     (Source_Filename : String;
      Valid           : Boolean;
      Pool            : Xref_Pool);
   --  Set valid flag for given source file name.
   --  Does nothing if no xref file for givent file was generated yet.

private

   type Hash_Range is range 1 .. 1000;

   type Xref_Elmt_Record;
   type Xref_Elmt_Ptr is access all Xref_Elmt_Record;

   type Xref_Elmt_Record is record
      Source_Filename   : String_Access;
      Xref_Filename     : String_Access;
      Valid             : Boolean := False;
      Next              : Xref_Elmt_Ptr;
   end record;

   Null_Xref_Elmt : constant Xref_Elmt_Ptr := null;

   procedure Set_Next (Xref : Xref_Elmt_Ptr; Next : Xref_Elmt_Ptr);
   function Next (Xref : Xref_Elmt_Ptr) return Xref_Elmt_Ptr;
   function Get_Key (Xref : Xref_Elmt_Ptr) return String_Access;
   function Hash (Key : String_Access) return Hash_Range;
   function Equal (K1, K2 : String_Access) return Boolean;

   package STable is new HTables.Static_HTable
     (Header_Num  => Hash_Range,
      Element     => Xref_Elmt_Record,
      Elmt_Ptr    => Xref_Elmt_Ptr,
      Null_Ptr    => Null_Xref_Elmt,
      Set_Next    => Set_Next,
      Next        => Next,
      Key         => String_Access,
      Get_Key     => Get_Key,
      Hash        => Hash,
      Equal       => Equal);

   type Xref_Pool is access all STable.HTable;
   Empty_Xref_Pool : constant Xref_Pool := null;

end SN.Xref_Pools;
