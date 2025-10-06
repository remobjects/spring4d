{
delphi7��֧��olevariantת����int64
����Ҫ��ת����double���ͱ���ķ�ʽ,
����һ�ַ�ʽ�����Լ�д����ʵ�ֲ���
}

unit uInt64OleVariant;

interface

uses ActiveX;

function Int64ToOleVar( value: Int64 ): OleVariant;
function  OleVarToInt64( value:OleVariant ): Int64 ;

function OleVarToDouble(value:OleVariant):Double;
function DoubleToOleVar(value:Double):OleVariant;

implementation

//Download by thtp://www.codefans.net

//��64λ����ת����olevariant
function Int64ToOleVar( value: Int64 ): OleVariant;
begin
  TVarData(Result).VType := vt_i8;
  TVarData(Result).VInt64:= value;
end;

//��olevariantת����64λ����
function  OleVarToInt64( value:OleVariant ): Int64 ;
begin
  Result := 0;
  if TvarData(value).VType = VT_I8 then
  result := TVardata(value).VInt64;
end;

function OleVarToDouble(value:OleVariant):Double;
begin
  Result := 0;
 if TvarData(value).VType = VT_R8 then
  result := TVardata(value).VDouble;
end;

function DoubleToOleVar(value:Double):OleVariant;
begin
  TVarData(Result).VType := VT_R8;
  TVarData(Result).VDouble := value;
end;

end.
