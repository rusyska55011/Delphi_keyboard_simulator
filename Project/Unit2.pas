unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button3: TButton;
    Label15: TLabel;
    Label16: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
  public
  end;

var
  Form2: TForm2;

implementation
uses Unit1;

{$R *.dfm}

var i, pressed, delete_used, mistakes, seconds, minutes: Integer;
var time, speed, graph_speed: Real;
var word, question: String;
var exit, big: Boolean;
var char_getted: Char;

var words_arr: Array[1..15] of String;

var easy_words: Array[1..15] of String = (
'������', '������� �����', '������� ����',
'�������', '������� ����', '����� ����',
'���� ���', '������� ���������', '������ �����',
'���� �������', '���� ����', '�������� ����',
'����� ����', '����������', '������ ���'
);

var medium_words: Array[1..15] of String = (
'� - �����������', '� ����� � "���"', '��, � ���?',
'��������� ���, ����������!', '��� ������� �������, ��� ���� �����!', '������� �� �����!!!',
'�������, ��� �������!', '� - ������� ���', '����� ����, �����!',
'���� 2 = �����������', '����� ���� �������� ������ ������!', '������, �������, 5!',
'���� - �����, � ���!', '������ �� 15-�� ���������', '��� 57 ������ ����'
);

var hard_words: Array[1..15] of String = (
'��������! ����������� ��������� ����������� ������������ ����� ���������� ����������� �������� ����� �����������.',
'� ����� ������� ����� ����� � ��������� ��������� �������� ������� � ���� ������ �����, ����� �������� �����.',
'����������� ��� �� ��� �����, ��� ���� �������� � ������� ���, �� ����� ��� �������� �� ������ � �������.',
'������� ����� �� ����� ��������������� � ���� �������������������� �������, ��� �������� ����������� � �����.',
'��������� ������ �������������� �� ���������� �������. ����� ������� �������� ����-������.',
'�� ����� ������������ ��������������� ����� ��� �������� ��������. ����������� ������ ��� ������������.',
'���������, ��� ������ ��������� ��� �������� � ������������ � ����� ����� �����. �� ��� �����?',
'������������ ���������� ����� ������������ ������ ����� �����. ��� ���������� ����� ���� �����.',
'���� ���������� ������� (��� ������) �� ������ ����������. ��� ���� ������ ����������� ������� �����������.',
'������� ���� �� ������������ ���� ����� ��� ����������� ���������� �, � �.�. ��� ����������. ��� � ��� �������!',
'�������������� ��������� ��������� ������ � ����� ����� ����� ������, ��� ���� ������ ������������� �����.',
'���� �� ����� ���������������� ��� ��� ���������� � ���� ����� ������.',
'���������� ������, ��������� ������ ������, ������� ������ ����������. ��� ����������� ������� �������� ������!',
'�������, ����������, ��� � ����� ������ ���������, ������ ����� �������� ������ ������������� �������.',
'������� ��������� ���� �������� �������� ������, ���������� ������, ������, ������ � ��.'
);


procedure TForm2.Button1Click(Sender: TObject);
begin
  {� ����������� �� ����, ����� �� radiobutton �������, ����������
   ������ � ������� � ����������� � ������}
  if Form1.RadioButton1.Checked = True then begin
    for i := 1 to 15 do begin
      words_arr[i] := easy_words[i];
    end;
  end
  else
    if Form1.RadioButton2.Checked = True then begin
      for i := 1 to 15 do begin
        words_arr[i] := medium_words[i];
      end;
    end
    else
      if Form1.RadioButton3.Checked = True then begin
        for i := 1 to 15 do begin
          words_arr[i] := hard_words[i];
        end;
      end;

  {�������� ��� ������ ����������}
  word := '';
  exit := False;
  big := False;

  pressed := 0;
  delete_used := 0;
  mistakes := 0;
  speed := 0;

  seconds := 0;
  minutes := 0;
  time := 0;

  {�������� ������ ������ � ������}
  Button1.Visible := False;
  Button2.Visible := False;
  Button3.Visible := False;
  Button4.Visible := False;

  {�������� ������ ������}
  question := words_arr[Random(14) + 1];
  Label1.Caption := question;

  {������������ ����� ������ 1000 ������}
  while seconds + (minutes * 60) < 1000 do begin
    {���� for �������� �� ���� id ������}
    for i:=0 to 255 do
      {���� id ������ ������, ����������� ��. �������...}
      if getasynckeystate(i)<>0 then begin
        {����� ������ ������ ����� ��� BackSpace(8), Caps(20), Esc(27),
         Space(32), Tab(9) ����� ��������� ���� �������}
        case i of
          8: begin
            if length(word) > 0 then begin
              {�������� ���������� ������� � ������}
              delete(word, length(word), length(word));
              delete_used := delete_used + 1;
              sleep(10);
            end;
          end;
          20: begin
            case big of
              True: big := False;
              False: big := True;
            end;
            sleep(10);
          end;
          27: exit := True;
          32: begin
            word := word + ' ';
            sleep(10);
          end;
          9: begin
            word := word + '   ';
            sleep(10);
          end;
        else

          {�������� ����� ������� (i), � ������ �������� ��� ������}
          char_getted := Chr(i);

          {���� ���� �� ��� ����� - ������������ ������� � ��������� ������� �����}
          if big = False then begin
            case char_getted of
              {� ������ ����������� �����; ������� ������� ������ + 1; ���� ��������� ����� ������ �� ����� ����� �� �� ������� ����� ����������� �����, �� ������� ������ + 1;}
              'Q':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'W':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'E':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'R':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'T':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Y':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'U':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'I':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'O':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'P':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'A':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'S':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'D':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'F':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'G':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'H':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'J':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'K':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'L':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Z':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'X':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'C':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'V':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'B':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'N':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'M':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '1':begin word := word + '1'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '2':begin word := word + '2'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '3':begin word := word + '3'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '4':begin word := word + '4'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '5':begin word := word + '5'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '6':begin word := word + '6'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '7':begin word := word + '7'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '8':begin word := word + '8'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '9':begin word := word + '9'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '0':begin word := word + '0'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '-'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '+'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '.'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '\'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
            end;
          end
          {� ��������� ������, - ���� big ����������, ���������� � ���� = true
           �������� � ������� ������� �����}
          else begin
            case char_getted of
              'Q':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'W':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'E':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'R':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'T':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Y':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'U':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'I':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'O':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'P':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'A':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'S':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'D':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'F':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'G':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'H':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'J':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'K':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'L':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'Z':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'X':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'C':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'V':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'B':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'N':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              'M':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '1':begin word := word + '!'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '2':begin word := word + '"'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '3':begin word := word + '�'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '4':begin word := word + ';'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '5':begin word := word + '%'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '6':begin word := word + ':'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '7':begin word := word + '?'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '8':begin word := word + '*'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '9':begin word := word + '('; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '0':begin word := word + ')'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '_'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '='; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + ','; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
              '�':begin word := word + '/'; pressed := pressed + 1; if word[length(word)] <> question[length(word)] then mistakes := mistakes + 1; end;
            end;
          end;
      end;
      {������������ ������ �� ������}
      Label5.Caption := word;
    end;

      {���� ��� ����� Esc, ������ exit = True, ������ - ������ �� ����� ����
       (��� ����������� ���� ������ ������ �� ��������� ������, ����� �� ������
        ������ �� ����� for, �������� ������, � �� �� ����� ����!)}
      if exit = True then begin
        break;
      end;

      {���� ������ ����������� ����� = ������ �����������, �� ���������� ��.
      ����� ��������, ���������� ������, ������� ������ �����}
      if length(word) = length(question) then begin
        question := words_arr[random(14) + 1];
        Label1.Caption := question;
        word := '';
        Label5.Caption := word;
      end;

      {�.�. �������� ���� ����� � 0.9 ������ + ������ ��������� ��������
       0.01 ������, ���������� 0.1 � �������� �� ������ ����}
      time := time + 0.1;
      {��������� ����� � ��������� ������ � int, � ������� �������}
      seconds := Round(time);

      {���� (�������� ������� �� 60 � ��������, � ��������� 0) � (������ > 1),
       �� ���������� � ������� + , ������� ������� � ������� ��������}
      if (seconds mod 60 = 0) and (time >= 1) then begin
        minutes := minutes + 1;
        time := 0;
        seconds := 0;
      end;

      {������� ������� �����: ���� (������ ������������ � ������ ������ < 2) �
      (������ ������������ � ������ ����� < 2), �� ����� ��������� �����, �
      ������ ������� ������������ ����, ����� ���� �� ���, � 1:5, � ��� 01:05}
      if (length(IntToStr(seconds)) < 2) and (length(IntToStr(minutes)) < 2) then begin
        Label10.Caption := '0' + IntToStr(minutes) + ' : ' + '0' + IntToStr(Round(time));
      end
      else begin
        {����� ������� ��� ������ �������� �������...}
        if length(IntToStr(minutes)) < 2 then begin
          Label10.Caption := '0' + IntToStr(minutes) + ' : ' + IntToStr(Round(time));
        end
        else begin
          if length(IntToStr(seconds)) < 2 then begin
            Label10.Caption := IntToStr(minutes) + ' : ' + '0' + IntToStr(Round(time));
          end
          else begin
            Label10.Caption := IntToStr(minutes) + ' : ' + IntToStr(Round(time));
          end;
        end;
      end;

      if (pressed > 1) and (seconds + (minutes * 60) > 1) then begin
        {����������� ������� �������� ������}
        speed := pressed / (seconds + (minutes * 60));

        {� ������ ������}
        with Image1.Canvas do begin
          Pen.Color := clGreen;
          LineTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
          MoveTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
        end;
      end
      else begin
        {������ ����� ������� ��������� ����� ������ ����� ������� ������ �����}
        Image1.Canvas.MoveTo(10 + Round(seconds + (minutes * 60)), Image1.Height - Round(speed * 40) - 10);
      end;

      {������������ ��������}
      Label2.Caption := IntToStr(pressed);
      Label3.Caption := IntToStr(delete_used);
      Label4.Caption := IntToStr(mistakes);
      Label12.Caption := formatfloat('0.00', speed);

      {� ���� �����}
      self.Repaint;

      {��������, ����� ����� �� ������������ + �� ���� ���������� ���������}
      sleep(88);
    end;

    {��� ����� ���������� ���� ������������ ������}
    Button1.Visible := True;
    Button2.Visible := True;
    Button3.Visible := True;
    Button4.Visible := True;
end;


procedure TForm2.Button2Click(Sender: TObject);
begin
  {��� ������ ���������� ������� �����, ����������� �����������}
  Form1.Visible := True;
  Form2.Visible := False;

  {������������ ������ �������}
  Button3Click(Sender);
end;

procedure TForm2.FormCreate(Sender: TObject);
var i, x, y, sch: Integer;
begin
  with Image1.Canvas do begin
    Pen.Color := clRed;

    {������������ �����}
    MoveTo(10, Image1.Height - 10);
    LineTo(Image1.Width - 10, Image1.Height - 10);

    {�������������� �����}
    MoveTo(10, 10);
    LineTo(10, Image1.Height - 10);

    {�������� �� ���������� ��� �������������� �����}
    x := 40;
    while x < Image1.Width - 30 do begin
      MoveTo(x , Image1.Height - 15);
      LineTo(x, Image1.Height - 5);
      TextOut(x - 5, Image1.Height - 30, IntToStr(x));
      x := x + 40;
    end;

    {��� ������������}
    y := 40;
    sch := 1;
    while y < Image1.Height - 20 do begin
      MoveTo(5, Image1.Height - y);
      LineTo(15, Image1.Height - y);
      TextOut(20, Image1.Height - y - 5, IntToStr(sch));
      sch := sch + 1;
      y := y + 40;
    end;
  end;
end;


procedure TForm2.Button3Click(Sender: TObject);
begin
  {����������� ��� �����}
  Image1.Canvas.Pen.Color := clWhite;
  Image1.Canvas.Rectangle(0, 0, Image1.Width,Image1.Height);

  {�������� ���������, ��� �������� �����}
  FormCreate(Sender);

  {�������� ��������}
  Label2.Caption := '0';
  Label3.Caption := '0';
  Label4.Caption := '0';
  Label10.Caption := '00 : 00';
  Label12.Caption := '0';
  {� �����}
  Label1.Caption := '*����� ����� ���������� �����';
  Label5.Caption := '';
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  {��� �������� ������� ����� - ����������� � ��� ���������}
  Form1.close;
end;

end.
