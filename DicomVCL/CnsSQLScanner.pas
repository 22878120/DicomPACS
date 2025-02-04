// Generated by ParserBuilder @ 2012-5-19 ���� 09:46:38

unit CnsSQLScanner;

(* NOTE: Any changes made to this file may be overwritten when it gets regenerated
  from within ParserBuilder *)

interface

uses
  Windows, Messages, SysUtils, Classes;

const
  BlkSize = 16384;
  TAB = #09;
  _LF = #10;
  _CR = #13;
  _EF = #0;
  EF = #0;
  _EL = _CR;
  LineEnds: array[0..2] of char = (#13, #10, #0);
  CRLF = #13#10;

type
  TBufBlock = array [0..BlkSize - 1] of char;
  TCocoBuffer = array [0..1024] of ^TBufBlock;
  TStartTable = array [0..255] of integer;
  TGetCH = procedure(pos: longint; Var retCh : Char) of object;
  TCocoErrorProc = procedure(nr, line, col: integer; pos: integer) of object;

type
  TCnsSQLScanner = class(TObject)
  private
    lastCh,
    ch: char;       (*current input character*)
    curLine: integer;    (*current input line (may be higher than line)*)
    lineStart: longint;    (*start position of current line*)
    apx: longint;    (*length of appendix (CONTEXT phrase)*)
    oldEols: integer;    (*number of _EOLs in a comment*)
    bp, bp0: longint;    (*current position in buf
                           (bp0: position of current token)*)
    LBlkSize: longint;    (*BlkSize*)
    inputLen: longint;    (*source file size*)
    buf: TCocoBuffer;     (*source buffer for low-level access*)
    start: TStartTable; (*start state for every character*)
    CurrentCh: TGetCH;
    {----------------}
    FnextLen: integer;
    Fpos: integer;
    Fcol: integer;
    FnextCol: integer;
    FnextPos: integer;
    Flen: integer;
    FnextLine: integer;
    Fline: integer;
    Fdirectory: string;
    FError: TCocoErrorProc;
    FOutputDirectory: string;
    procedure Err(nr, line, col: integer; pos: longint);
    procedure NextCh;
    function Comment: boolean;
    procedure CapChAt(pos: longint; var retChar : Char);
    procedure DisposeBuf;
  protected
  public
    src: TStringStream;         (*source/list files. To be opened by the main pgm*)
    lst: TStringStream;
    Ferrors: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Get(var sym: integer);
    (* Gets next symbol from source file *)
    procedure GetString(pos: longint; len: integer; var s: string);
    (* Retrieves exact string of max length len from position pos in source file *)
    procedure GetName(pos: longint; len: integer; var s: string);
    (* Retrieves name of symbol of length len at position pos in source file *)
    procedure CharAt(pos: longint; var retChar : Char);
    (* Returns exact character at position pos in source file *)
    procedure _Reset;
    (* Reads and stores source file internally *)
    property Error: TCocoErrorProc read FError write FError;
  published
    { Published declarations }
    property directory: string read Fdirectory write Fdirectory;
    (*of source file*)
    property OutputDirectory: string read FOutputDirectory write FOutputDirectory;
    property line: integer read Fline write Fline;
    (*line and column of current symbol*)
    property col: integer read Fcol write Fcol;
    (*line and column of current symbol*)
    property len: integer read Flen write Flen;      (*length of current symbol*)
    property pos: integer read Fpos write Fpos;
    (*file position of current symbol*)
    property nextLine: integer read FnextLine write FnextLine;
    (*line of lookahead symbol*)
    property nextCol: integer read FnextCol write FnextCol;
    (*column of lookahead symbol*)
    property nextLen: integer read FnextLen write FnextLen;
    (*length of lookahead symbol*)
    property nextPos: integer read FnextPos write FnextPos;
    (*file position of lookahead symbol*)
    property errors: integer read Ferrors write Ferrors;
    (*number of detected errors*)
  end;


implementation



const
  no_Sym = 124; (*error token code*)
  (* not only for errors but also for not finished states of scanner analysis *)
  _EOF = #26; (*MS-DOS _EOF*)

Procedure TCnsSQLScanner.CapChAt(pos: longint; var retChar : Char);
var
  ch: char;
begin
  if pos >= inputLen then
  begin
    retChar := EF;
    EXIT;
  end;
  ch := upcase(buf[pos div LBlkSize]^[pos mod LBlkSize]);
  if ch <> _EOF then retChar := ch
  else
    retChar := EF
end;

Procedure TCnsSQLScanner.CharAt(pos: longint; var retChar : Char);
var
  ch: char;
begin
  if pos >= inputLen then
  begin
    retChar := EF;
    EXIT;
  end;
  ch := buf[pos div LBlkSize]^[pos mod LBlkSize];
  if ch <> _EOF then retChar := ch
  else
    retChar := EF
end;

function TCnsSQLScanner.Comment: boolean;
label
  999;
  VAR
    level: INTEGER;
    oldLineStart{,startLine} : LONGINT;
  BEGIN
    level := 1; oldLineStart := lineStart;
IF (ch = '(') THEN BEGIN
  
NextCh;
  
IF (ch = '*') THEN BEGIN
    
NextCh;
    
WHILE TRUE DO BEGIN
      
IF (ch = '*') THEN BEGIN
        
NextCh;
        
IF (ch = ')') THEN BEGIN
          
DEC(level); NextCh;
          
IF level = 0 THEN BEGIN Comment := TRUE; GOTO 999; END
        
END
      
END ELSE IF (ch = '(') THEN BEGIN
        
NextCh;
        
IF (ch = '*') THEN BEGIN INC(level); NextCh END
      
END ELSE IF ch = EF THEN BEGIN Comment := FALSE; GOTO 999; END
      
ELSE NextCh;
    
END; (* WHILE TRUE *)
  
END ELSE BEGIN
    
IF (ch = _CR) OR (ch = _LF) THEN BEGIN
      
DEC(curLine); lineStart := oldLineStart
    
END;
    
DEC(bp); ch := lastCh;
  
END;

END;

Comment := FALSE;
    999:
end;


procedure TCnsSQLScanner.Err(nr, line, col, pos: integer);
begin
  INC(Ferrors)
end;

procedure TCnsSQLScanner.Get(var sym: integer);
var
  state: integer;

  function Equal(s: string): boolean;
  var
    i: integer;
    q: longint;
    cc : Char; // Current Char returned from modifed TGetCh
  begin
    if nextLen <> Length(s) then
    begin
      Equal := False;
      EXIT
    end;
    i := 1;
    q := bp0;
    while i <= nextLen do
    begin
      CurrentCh(q,cc);
      if cc <> s[i] then
      begin
        Equal := False;
        EXIT
      end;
      INC(i);
      INC(q)
    end;
    Equal := True
  end;

  procedure CheckLiteral;
  Var cc : Char;
  begin
    CurrentCh(bp0,cc);
CASE cc OF
    
  '(': IF Equal('(') THEN BEGIN sym := 16; 
          
 END;
    
  ')': IF Equal(')') THEN BEGIN sym := 17; 
          
 END;
    
  ',': IF Equal(',') THEN BEGIN sym := 24; 
          
 END;
    
  ';': IF Equal(';') THEN BEGIN sym := 57; 
          
 END;
    
  'A': IF Equal('AFTER') THEN BEGIN sym := 75; 
          
 END ELSE IF Equal('ALL') THEN BEGIN sym := 45; 
          
 END ELSE IF Equal('ANALYZE') THEN BEGIN sym := 50; 
          
 END ELSE IF Equal('ANALYZEFIELD') THEN BEGIN sym := 41; 
          
 END ELSE IF Equal('ASC') THEN BEGIN sym := 92; 
          
 END ELSE IF Equal('ASCENDING') THEN BEGIN sym := 93; 
          
 END ELSE IF Equal('AUTO') THEN BEGIN sym := 99; 
          
 END ELSE IF Equal('AUTOCREATE') THEN BEGIN sym := 26; 
          
 END ELSE IF Equal('AUTOINC') THEN BEGIN sym := 114; 
          
 END;
    
  'B': IF Equal('BLOB') THEN BEGIN sym := 115; 
          
 END ELSE IF Equal('BOOLEAN') THEN BEGIN sym := 110; 
          
 END ELSE IF Equal('BY') THEN BEGIN sym := 23; 
          
 END ELSE IF Equal('BYTES') THEN BEGIN sym := 123; 
          
 END;
    
  'C': IF Equal('CAL') THEN BEGIN sym := 55; 
          
 END ELSE IF Equal('CAN') THEN BEGIN sym := 98; 
          
 END ELSE IF Equal('CHAR') THEN BEGIN sym := 117; 
          
 END ELSE IF Equal('CHARACTER') THEN BEGIN sym := 118; 
          
 END ELSE IF Equal('CLASS') THEN BEGIN sym := 70; 
          
 END ELSE IF Equal('COL') THEN BEGIN sym := 52; 
          
 END ELSE IF Equal('COLOR') THEN BEGIN sym := 66; 
          
 END ELSE IF Equal('COMBIN') THEN BEGIN sym := 49; 
          
 END ELSE IF Equal('CONTROL') THEN BEGIN sym := 96; 
          
 END ELSE IF Equal('COUNT') THEN BEGIN sym := 54; 
          
 END ELSE IF Equal('COUNTFIRST') THEN BEGIN sym := 29; 
          
 END;
    
  'D': IF Equal('DATABASE') THEN BEGIN sym := 13; 
          
 END ELSE IF Equal('DATASET') THEN BEGIN sym := 21; 
          
 END ELSE IF Equal('DATE') THEN BEGIN sym := 109; 
          
 END ELSE IF Equal('DECIMAL') THEN BEGIN sym := 120; 
          
 END ELSE IF Equal('DEFAULT') THEN BEGIN sym := 63; 
          
 END ELSE IF Equal('DESC') THEN BEGIN sym := 94; 
          
 END ELSE IF Equal('DESCENDING') THEN BEGIN sym := 95; 
          
 END ELSE IF Equal('DETAIL') THEN BEGIN sym := 74; 
          
 END ELSE IF Equal('DISABLE') THEN BEGIN sym := 64; 
          
 END ELSE IF Equal('DISPLAY') THEN BEGIN sym := 104; 
          
 END;
    
  'E': IF Equal('ENABLE') THEN BEGIN sym := 65; 
          
 END;
    
  'F': IF Equal('FETCH') THEN BEGIN sym := 14; 
          
 END ELSE IF Equal('FIELD') THEN BEGIN sym := 35; 
          
 END ELSE IF Equal('FLOAT') THEN BEGIN sym := 122; 
          
 END ELSE IF Equal('FOR') THEN BEGIN sym := 67; 
          
 END ELSE IF Equal('FROM') THEN BEGIN sym := 18; 
          
 END;
    
  'G': IF Equal('GROUP') THEN BEGIN sym := 71; 
          
 END;
    
  'H': IF Equal('HINT') THEN BEGIN sym := 46; 
          
 END;
    
  'I': IF Equal('IMAGEINDEX') THEN BEGIN sym := 47; 
          
 END ELSE IF Equal('INT') THEN BEGIN sym := 107; 
          
 END ELSE IF Equal('INTEGER') THEN BEGIN sym := 106; 
          
 END ELSE IF Equal('IS') THEN BEGIN sym := 12; 
          
 END;
    
  'K': IF Equal('KEY') THEN BEGIN sym := 40; 
          
 END;
    
  'L': IF Equal('LARGEINT') THEN BEGIN sym := 108; 
          
 END ELSE IF Equal('LOGEXEC') THEN BEGIN sym := 27; 
          
 END ELSE IF Equal('LOGTIME') THEN BEGIN sym := 28; 
          
 END ELSE IF Equal('LOOKUP') THEN BEGIN sym := 76; 
          
 END;
    
  'M': IF Equal('MASTER') THEN BEGIN sym := 22; 
          
 END ELSE IF Equal('MAX') THEN BEGIN sym := 90; 
          
 END ELSE IF Equal('MAXIMUM') THEN BEGIN sym := 91; 
          
 END ELSE IF Equal('MEMO') THEN BEGIN sym := 116; 
          
 END ELSE IF Equal('MIN') THEN BEGIN sym := 88; 
          
 END ELSE IF Equal('MINIMUM') THEN BEGIN sym := 89; 
          
 END ELSE IF Equal('MONEY') THEN BEGIN sym := 113; 
          
 END ELSE IF Equal('MULTIDATABASE') THEN BEGIN sym := 31; 
          
 END;
    
  'N': IF Equal('NEEDLOCK') THEN BEGIN sym := 30; 
          
 END ELSE IF Equal('NOT') THEN BEGIN sym := 86; 
          
 END ELSE IF Equal('NULL') THEN BEGIN sym := 87; 
          
 END ELSE IF Equal('NUMERIC') THEN BEGIN sym := 121; 
          
 END;
    
  'O': IF Equal('OF') THEN BEGIN sym := 77; 
          
 END ELSE IF Equal('ON') THEN BEGIN sym := 73; 
          
 END ELSE IF Equal('ORDER') THEN BEGIN sym := 69; 
          
 END ELSE IF Equal('OWNER') THEN BEGIN sym := 32; 
          
 END;
    
  'P': IF Equal('PICTUREMASK') THEN BEGIN sym := 97; 
          
 END ELSE IF Equal('PLUGIN') THEN BEGIN sym := 11; 
          
 END ELSE IF Equal('PRIMARY') THEN BEGIN sym := 39; 
          
 END ELSE IF Equal('PROFILE') THEN BEGIN sym := 36; 
          
 END ELSE IF Equal('PROGRAM') THEN BEGIN sym := 43; 
          
 END ELSE IF Equal('PROMPT') THEN BEGIN sym := 84; 
          
 END ELSE IF Equal('PROMPT1') THEN BEGIN sym := 79; 
          
 END ELSE IF Equal('PROMPT2') THEN BEGIN sym := 80; 
          
 END ELSE IF Equal('PROMPT3') THEN BEGIN sym := 81; 
          
 END ELSE IF Equal('PROMPT4') THEN BEGIN sym := 82; 
          
 END ELSE IF Equal('PROMPT5') THEN BEGIN sym := 83; 
          
 END;
    
  'Q': IF Equal('QUERY') THEN BEGIN sym := 48; 
          
 END;
    
  'R': IF Equal('RANGE') THEN BEGIN sym := 56; 
          
 END ELSE IF Equal('READONLY') THEN BEGIN sym := 61; 
          
 END ELSE IF Equal('REMMBER') THEN BEGIN sym := 100; 
          
 END ELSE IF Equal('REPORT') THEN BEGIN sym := 38; 
          
 END ELSE IF Equal('ROW') THEN BEGIN sym := 51; 
          
 END;
    
  'S': IF Equal('SAME_PROFILE') THEN BEGIN sym := 78; 
          
 END ELSE IF Equal('SELF') THEN BEGIN sym := 68; 
          
 END ELSE IF Equal('SMALLINT') THEN BEGIN sym := 105; 
          
 END ELSE IF Equal('SPERATE') THEN BEGIN sym := 72; 
          
 END ELSE IF Equal('STATE') THEN BEGIN sym := 34; 
          
 END ELSE IF Equal('SUM') THEN BEGIN sym := 53; 
          
 END;
    
  'T': IF Equal('TABLE') THEN BEGIN sym := 25; 
          
 END ELSE IF Equal('TABLEGROUP') THEN BEGIN sym := 5; 
          
 END ELSE IF Equal('TASK') THEN BEGIN sym := 20; 
          
 END ELSE IF Equal('TASKGROUP') THEN BEGIN sym := 8; 
          
 END ELSE IF Equal('TIME') THEN BEGIN sym := 111; 
          
 END ELSE IF Equal('TIMESTAMP') THEN BEGIN sym := 112; 
          
 END ELSE IF Equal('TO') THEN BEGIN sym := 44; 
          
 END ELSE IF Equal('TREEFIELD') THEN BEGIN sym := 101; 
          
 END ELSE IF Equal('TRIGGER') THEN BEGIN sym := 42; 
          
 END;
    
  'U': IF Equal('USERFIELD') THEN BEGIN sym := 33; 
          
 END ELSE IF Equal('USERGROUP') THEN BEGIN sym := 37; 
          
 END;
    
  'V': IF Equal('VALUE') THEN BEGIN sym := 59; 
          
 END ELSE IF Equal('VALUES') THEN BEGIN sym := 85; 
          
 END ELSE IF Equal('VARCHAR') THEN BEGIN sym := 119; 
          
 END ELSE IF Equal('VIEW') THEN BEGIN sym := 10; 
          
 END ELSE IF Equal('VIEWGROUP') THEN BEGIN sym := 9; 
          
 END;
    
  'W': IF Equal('WHERE') THEN BEGIN sym := 19; 
          
 END ELSE IF Equal('WIDTHINDIALOG') THEN BEGIN sym := 103; 
          
 END ELSE IF Equal('WIDTHINGRID') THEN BEGIN sym := 102; 
          
 END ELSE IF Equal('WRITEONLY') THEN BEGIN sym := 62; 
          
 END;
    
  '{': IF Equal('{') THEN BEGIN sym := 6; 
          
 END;
    
  '}': IF Equal('}') THEN BEGIN sym := 7; 
          
 END;
    
ELSE BEGIN END
    
END
  end;

begin (*Get*)
  WHILE (ch = ' ') OR
        
((ch >= CHR(1)) AND (ch <= CHR(31))) DO NextCh;
  
IF ((ch = '(')) AND Comment THEN BEGIN Get(sym); EXIT; END;
  pos := nextPos;
  nextPos := bp;
  col := nextCol;
  nextCol := bp - lineStart;
  line := nextLine;
  nextLine := curLine;
  len := nextLen;
  nextLen := 0;
  apx := 0;
  state := start[Ord(ch)];
  bp0 := bp;
  while True do
  begin
    NextCh;
    INC(FnextLen);
    case state of
       1  : IF ((ch = '.') OR
             
(ch >= '0') AND (ch <= '9') OR
             
(ch >= 'A') AND (ch <= 'Z') OR
             
(ch = '_') OR
             
(ch >= CHR(129))) THEN BEGIN 
           
END ELSE BEGIN sym := 1; CheckLiteral; EXIT; END;
     
  2  : IF ((ch >= '0') AND (ch <= '9')) THEN BEGIN 
           
END ELSE BEGIN sym := 2; EXIT; END;
     
  3  : IF ((ch = CHR(0)) OR
             
(ch >= ' ') AND (ch <= '!') OR
             
(ch >= '#')) THEN BEGIN 
           
END ELSE IF (ch = '"') THEN BEGIN state := 5; 
           
END ELSE BEGIN sym := no_Sym; EXIT; END;
     
  4  : IF ((ch = CHR(0)) OR
             
(ch >= ' ') AND (ch <= '&') OR
             
(ch >= '(')) THEN BEGIN 
           
END ELSE IF (ch = CHR(39)) THEN BEGIN state := 5; 
           
END ELSE BEGIN sym := no_Sym; EXIT; END;
     
  5  : BEGIN sym := 3; EXIT; END;
     
  6  : BEGIN sym := 4; CheckLiteral; EXIT; END;
     
  7  : BEGIN sym := 15; EXIT; END;
     
  8  : BEGIN sym := 58; EXIT; END;
     
  9  : BEGIN sym := 60; EXIT; END;
     
  10  : BEGIN sym := 0; ch := #0; DEC(bp); EXIT END;
      else
      begin
        sym := no_Sym;
        EXIT (*NextCh already done*)
      end;
    end
  end
end;


procedure TCnsSQLScanner.GetName(pos, len: integer; var s: string);
var
  i: integer;
  p: longint;
  cc : Char;
begin
  if len > 255 then len := 255;
  p := pos;
  i := 1;
  SetLength(S,Len);
  while i <= len do
  begin
    CurrentCh(p,cc);
    s[i] := cc;
    INC(i);
    INC(p)
  end;
end;


procedure TCnsSQLScanner.GetString(pos, len: integer; var s: string);
var
  i: integer;
  p: longint;
  cc : Char;
begin
  if len > 255 then len := 255;
  p := pos;
  i := 1;
  setLength(S,len);
  while i <= len do
  begin
    CharAt(p,cc);
    s[i] := cc;
    INC(i);
    INC(p)
  end;
end;

procedure TCnsSQLScanner.NextCh;
  (* Return global variable ch *)
  Var cc : Char;
begin
  lastCh := ch;
  INC(bp);
  CurrentCh(bp,cc);
  ch := cc;
  if (ch = _EL) or (ch = _LF) and (lastCh <> _EL) then
  begin
    INC(curLine);
    lineStart := bp
  end
end;


procedure TCnsSQLScanner._Reset;
var
  len: longint;
  i, Read: integer;
  AmtTransferred: Integer;
begin (*assert: src has been opened*)
//  len := FileSize(src);
  Len := src.Size;
  DisposeBuf;
  i := 0;
  inputLen := len;
  while len > LBlkSize do
  begin
    NEW(buf[i]);
    Read := BlkSize;
//    BlockRead(src, buf[i]^, Read,AmtTransferred);
    AmtTransferred := src.Read(buf[i]^, Read);
    len := len - AmtTransferred;
    INC(i)
  end;
  NEW(buf[i]);
  Read := len;
  //AmtTransferred :=
  src.Read(buf[i]^, Read);
  buf[i]^[Read] := EF;
  curLine := 1;
  lineStart := -2;
  bp := -1;
  oldEols := 0;
  apx := 0;
  errors := 0;
  NextCh;
end;

constructor TCnsSQLScanner.Create;
begin
  inherited;
  lst:= TStringStream.Create('');
  src := NIL;
  CurrentCh := CapChAt;
  
start[0   ] := 10  ; start[1   ] := 11  ; start[2   ] := 11  ; start[3   ] := 11  ; 
  
start[4   ] := 11  ; start[5   ] := 11  ; start[6   ] := 11  ; start[7   ] := 11  ; 
  
start[8   ] := 11  ; start[9   ] := 11  ; start[10   ] := 11  ; start[11   ] := 11  ; 
  
start[12   ] := 11  ; start[13   ] := 11  ; start[14   ] := 11  ; start[15   ] := 11  ; 
  
start[16   ] := 11  ; start[17   ] := 11  ; start[18   ] := 11  ; start[19   ] := 11  ; 
  
start[20   ] := 11  ; start[21   ] := 11  ; start[22   ] := 11  ; start[23   ] := 11  ; 
  
start[24   ] := 11  ; start[25   ] := 11  ; start[26   ] := 11  ; start[27   ] := 11  ; 
  
start[28   ] := 11  ; start[29   ] := 11  ; start[30   ] := 11  ; start[31   ] := 11  ; 
  
start[32   ] := 11  ; start[33   ] := 11  ; start[34   ] := 3  ; start[35   ] := 11  ; 
  
start[36   ] := 11  ; start[37   ] := 6  ; start[38   ] := 11  ; start[39   ] := 4  ; 
  
start[40   ] := 6  ; start[41   ] := 6  ; start[42   ] := 6  ; start[43   ] := 11  ; 
  
start[44   ] := 6  ; start[45   ] := 6  ; start[46   ] := 6  ; start[47   ] := 6  ; 
  
start[48   ] := 2  ; start[49   ] := 2  ; start[50   ] := 2  ; start[51   ] := 2  ; 
  
start[52   ] := 2  ; start[53   ] := 2  ; start[54   ] := 2  ; start[55   ] := 2  ; 
  
start[56   ] := 2  ; start[57   ] := 2  ; start[58   ] := 6  ; start[59   ] := 6  ; 
  
start[60   ] := 8  ; start[61   ] := 7  ; start[62   ] := 9  ; start[63   ] := 11  ; 
  
start[64   ] := 6  ; start[65   ] := 1  ; start[66   ] := 1  ; start[67   ] := 1  ; 
  
start[68   ] := 1  ; start[69   ] := 1  ; start[70   ] := 1  ; start[71   ] := 1  ; 
  
start[72   ] := 1  ; start[73   ] := 1  ; start[74   ] := 1  ; start[75   ] := 1  ; 
  
start[76   ] := 1  ; start[77   ] := 1  ; start[78   ] := 1  ; start[79   ] := 1  ; 
  
start[80   ] := 1  ; start[81   ] := 1  ; start[82   ] := 1  ; start[83   ] := 1  ; 
  
start[84   ] := 1  ; start[85   ] := 1  ; start[86   ] := 1  ; start[87   ] := 1  ; 
  
start[88   ] := 1  ; start[89   ] := 1  ; start[90   ] := 1  ; start[91   ] := 11  ; 
  
start[92   ] := 11  ; start[93   ] := 11  ; start[94   ] := 11  ; start[95   ] := 1  ; 
  
start[96   ] := 11  ; start[97   ] := 11  ; start[98   ] := 11  ; start[99   ] := 11  ; 
  
start[100   ] := 11  ; start[101   ] := 11  ; start[102   ] := 11  ; start[103   ] := 11  ; 
  
start[104   ] := 11  ; start[105   ] := 11  ; start[106   ] := 11  ; start[107   ] := 11  ; 
  
start[108   ] := 11  ; start[109   ] := 11  ; start[110   ] := 11  ; start[111   ] := 11  ; 
  
start[112   ] := 11  ; start[113   ] := 11  ; start[114   ] := 11  ; start[115   ] := 11  ; 
  
start[116   ] := 11  ; start[117   ] := 11  ; start[118   ] := 11  ; start[119   ] := 11  ; 
  
start[120   ] := 11  ; start[121   ] := 11  ; start[122   ] := 11  ; start[123   ] := 6  ; 
  
start[124   ] := 11  ; start[125   ] := 6  ; start[126   ] := 11  ; start[127   ] := 11  ; 
  
start[128   ] := 11  ; start[129   ] := 1  ; start[130   ] := 1  ; start[131   ] := 1  ; 
  
start[132   ] := 1  ; start[133   ] := 1  ; start[134   ] := 1  ; start[135   ] := 1  ; 
  
start[136   ] := 1  ; start[137   ] := 1  ; start[138   ] := 1  ; start[139   ] := 1  ; 
  
start[140   ] := 1  ; start[141   ] := 1  ; start[142   ] := 1  ; start[143   ] := 1  ; 
  
start[144   ] := 1  ; start[145   ] := 1  ; start[146   ] := 1  ; start[147   ] := 1  ; 
  
start[148   ] := 1  ; start[149   ] := 1  ; start[150   ] := 1  ; start[151   ] := 1  ; 
  
start[152   ] := 1  ; start[153   ] := 1  ; start[154   ] := 1  ; start[155   ] := 1  ; 
  
start[156   ] := 1  ; start[157   ] := 1  ; start[158   ] := 1  ; start[159   ] := 1  ; 
  
start[160   ] := 1  ; start[161   ] := 1  ; start[162   ] := 1  ; start[163   ] := 1  ; 
  
start[164   ] := 1  ; start[165   ] := 1  ; start[166   ] := 1  ; start[167   ] := 1  ; 
  
start[168   ] := 1  ; start[169   ] := 1  ; start[170   ] := 1  ; start[171   ] := 1  ; 
  
start[172   ] := 1  ; start[173   ] := 1  ; start[174   ] := 1  ; start[175   ] := 1  ; 
  
start[176   ] := 1  ; start[177   ] := 1  ; start[178   ] := 1  ; start[179   ] := 1  ; 
  
start[180   ] := 1  ; start[181   ] := 1  ; start[182   ] := 1  ; start[183   ] := 1  ; 
  
start[184   ] := 1  ; start[185   ] := 1  ; start[186   ] := 1  ; start[187   ] := 1  ; 
  
start[188   ] := 1  ; start[189   ] := 1  ; start[190   ] := 1  ; start[191   ] := 1  ; 
  
start[192   ] := 1  ; start[193   ] := 1  ; start[194   ] := 1  ; start[195   ] := 1  ; 
  
start[196   ] := 1  ; start[197   ] := 1  ; start[198   ] := 1  ; start[199   ] := 1  ; 
  
start[200   ] := 1  ; start[201   ] := 1  ; start[202   ] := 1  ; start[203   ] := 1  ; 
  
start[204   ] := 1  ; start[205   ] := 1  ; start[206   ] := 1  ; start[207   ] := 1  ; 
  
start[208   ] := 1  ; start[209   ] := 1  ; start[210   ] := 1  ; start[211   ] := 1  ; 
  
start[212   ] := 1  ; start[213   ] := 1  ; start[214   ] := 1  ; start[215   ] := 1  ; 
  
start[216   ] := 1  ; start[217   ] := 1  ; start[218   ] := 1  ; start[219   ] := 1  ; 
  
start[220   ] := 1  ; start[221   ] := 1  ; start[222   ] := 1  ; start[223   ] := 1  ; 
  
start[224   ] := 1  ; start[225   ] := 1  ; start[226   ] := 1  ; start[227   ] := 1  ; 
  
start[228   ] := 1  ; start[229   ] := 1  ; start[230   ] := 1  ; start[231   ] := 1  ; 
  
start[232   ] := 1  ; start[233   ] := 1  ; start[234   ] := 1  ; start[235   ] := 1  ; 
  
start[236   ] := 1  ; start[237   ] := 1  ; start[238   ] := 1  ; start[239   ] := 1  ; 
  
start[240   ] := 1  ; start[241   ] := 1  ; start[242   ] := 1  ; start[243   ] := 1  ; 
  
start[244   ] := 1  ; start[245   ] := 1  ; start[246   ] := 1  ; start[247   ] := 1  ; 
  
start[248   ] := 1  ; start[249   ] := 1  ; start[250   ] := 1  ; start[251   ] := 1  ; 
  
start[252   ] := 1  ; start[253   ] := 1  ; start[254   ] := 1  ; start[255   ] := 1  ; 
  Error := Err;
  LBlkSize := BlkSize;
  lastCh := EF;
end;

destructor TCnsSQLScanner.Destroy;
begin
  if (src <> NIL) then
    src.Free;
  lst.Free;
  DisposeBuf;
  inherited;
end;

procedure TCnsSQLScanner.DisposeBuf;
var
  idx: integer;
begin
  for idx := 1024 downto 0 do
  begin
    if buf[idx] <> nil then
      Dispose(buf[idx]);
    buf[idx] := nil;
  end;
end;



end. (* CnsSQLScanner *)
