unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

var difficulty: Integer;

procedure TForm1.Button1Click(Sender: TObject);
begin
  {��� ������ ������ �� ���� ������}
  if (RadioButton1.Checked = True) or (RadioButton2.Checked = True) or (RadioButton3.Checked = True) then begin
    Form1.Visible := False;
    Form2.Visible := True;
  end
  {���� ��� �� ������� - ��������� ��������� �� ������}
  else
    Label3.Caption := '�������� ���������!';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  {��������� ������� �����, ��� ��������� ���������}
  Form1.close;
end;

end.
